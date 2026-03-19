# frozen_string_literal: true

# Statefully split input data by a specifiable token
#
# BufferedTokenizer takes a delimiter upon instantiation, or acts line-based
# by default. It allows input to be spoon-fed from some outside source which
# receives arbitrary length datagrams which may-or-may-not contain the token
# by which entities are delimited.
#
# @example
#   tokenizer = BufferedTokenizer.new("\n")
#   tokenizer.extract("foo\nbar")  #=> ["foo"]
#   tokenizer.extract("baz\n")     #=> ["barbaz"]
#   tokenizer.flush                 #=> ""
class BufferedTokenizer
  # Limit passed to String#split to preserve trailing empty fields
  SPLIT_LIMIT = -1

  # Return the delimiter overlap length
  #
  # The number of characters at the end of a chunk that may contain a
  # partial delimiter, equal to delimiter.length - 1.
  #
  # @example
  #   BufferedTokenizer.new("<>").overlap  #=> 1
  #
  # @return [Integer] delimiter.length - 1
  #
  # @api public
  attr_reader :overlap

  # Create a new BufferedTokenizer
  #
  # Operates on lines delimited by a delimiter, which is by default "\n".
  #
  # The input buffer is stored as an array. This is by far the most efficient
  # approach given language constraints (in C a linked list would be a more
  # appropriate data structure). Segments of input data are stored in a list
  # which is only joined when a token is reached, substantially reducing the
  # number of objects required for the operation.
  #
  # @example
  #   tokenizer = BufferedTokenizer.new("<>")
  #
  # @param delimiter [String] the token delimiter (default: "\n")
  #
  # @return [BufferedTokenizer]
  #
  # @api public
  def initialize(delimiter = "\n")
    @delimiter = delimiter
    @input = []
    @tail = +""
    @overlap = @delimiter.length - 1
  end

  # Return the byte size of the internal buffer
  #
  # Size is not cached and is determined every time this method is called
  # in order to optimize throughput for extract.
  #
  # @example
  #   tokenizer = BufferedTokenizer.new
  #   tokenizer.extract("foo")
  #   tokenizer.size  #=> 3
  #
  # @return [Integer]
  #
  # @api public
  def size
    @tail.length + @input.sum(&:length)
  end

  # Extract tokenized entities from the input data
  #
  # Extract takes an arbitrary string of input data and returns an array of
  # tokenized entities, provided there were any available to extract. This
  # makes for easy processing of datagrams using a pattern like:
  #
  #   tokenizer.extract(data).map { |entity| Decode(entity) }.each { ... }
  #
  # Using -1 makes split return "" if the token is at the end of
  # the string, meaning the last element is the start of the next chunk.
  #
  # @example
  #   tokenizer = BufferedTokenizer.new
  #   tokenizer.extract("foo\nbar")  #=> ["foo"]
  #
  # @param data [String] a chunk of input data
  #
  # @return [Array<String>] complete tokens extracted from the input
  #
  # @api public
  def extract(data)
    data = rejoin_split_delimiter(data)

    @input << @tail
    entities = data.split(@delimiter, SPLIT_LIMIT)
    @tail = entities.shift # : String

    consolidate_input(entities) if entities.length.positive?

    entities
  end

  # Flush the contents of the input buffer
  #
  # Return the contents of the input buffer even though a token has not
  # yet been encountered, then reset the buffer.
  #
  # @example
  #   tokenizer = BufferedTokenizer.new
  #   tokenizer.extract("foo\nbar")
  #   tokenizer.flush  #=> "bar"
  #
  # @return [String] the buffered input
  #
  # @api public
  def flush
    @input << @tail
    buffer = @input.join
    @input.clear
    @tail = +""
    buffer
  end

  private

  # Rejoin a delimiter that was split across two chunks
  #
  # When the delimiter is longer than one character, it may be split across
  # two successive chunks. Transfer the trailing overlap from @tail back onto
  # the front of the incoming data so that split can find the full delimiter.
  #
  # @param data [String] incoming data
  #
  # @return [String] data with any split delimiter prefix restored
  #
  # @api private
  def rejoin_split_delimiter(data)
    if @overlap.positive?
      tail_end = @tail[-@overlap..]
      @tail.slice!(-@overlap, @overlap)
      tail_end ? tail_end + data : data
    else
      data
    end
  end

  # Consolidate the input buffer into the first entity
  #
  # Once at least one delimiter has been found, join the accumulated input
  # buffer with the first entity and move the trailing partial into @tail.
  #
  # @param entities [Array<String>] split entities
  #
  # @return [void]
  #
  # @api private
  def consolidate_input(entities)
    @input << @tail
    entities.unshift @input.join
    @input.clear
    @tail = entities.pop # : String
  end
end

# Alias for {BufferedTokenizer}, matching the gem name
Buftok = BufferedTokenizer
