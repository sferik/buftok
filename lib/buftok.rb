# frozen_string_literal: true

# BufferedTokenizer takes a delimiter upon instantiation, or acts line-based
# by default.  It allows input to be spoon-fed from some outside source which
# receives arbitrary length datagrams which may-or-may-not contain the token
# by which entities are delimited.  In this respect it's ideally paired with
# something like EventMachine (http://rubyeventmachine.com/).
class BufferedTokenizer
  SPLIT_LIMIT = -1

  # New BufferedTokenizers will operate on lines delimited by a delimiter,
  # which is by default "\n".
  #
  # The input buffer is stored as an array.  This is by far the most efficient
  # approach given language constraints (in C a linked list would be a more
  # appropriate data structure).  Segments of input data are stored in a list
  # which is only joined when a token is reached, substantially reducing the
  # number of objects required for the operation.
  attr_reader :overlap

  def initialize(delimiter = "\n")
    @delimiter = delimiter
    @input = []
    @tail = +""
    @overlap = @delimiter.length - 1
  end

  # Determine the size of the internal buffer.
  #
  # Size is not cached and is determined every time this method is called
  # in order to optimize throughput for extract.
  def size
    @tail.length + @input.sum(&:length)
  end

  # Extract takes an arbitrary string of input data and returns an array of
  # tokenized entities, provided there were any available to extract.  This
  # makes for easy processing of datagrams using a pattern like:
  #
  #   tokenizer.extract(data).map { |entity| Decode(entity) }.each do ...
  #
  # Using -1 makes split to return "" if the token is at the end of
  # the string, meaning the last element is the start of the next chunk.
  def extract(data)
    data = rejoin_split_delimiter(data)

    @input << @tail
    entities = data.split(@delimiter, SPLIT_LIMIT)
    @tail = entities.shift # : String

    consolidate_input(entities) if entities.length.positive?

    entities
  end

  # Flush the contents of the input buffer, i.e. return the input buffer even though
  # a token has not yet been encountered
  def flush
    @input << @tail
    buffer = @input.join
    @input.clear
    @tail = +""
    buffer
  end

  private

  def consolidate_input(entities)
    @input << @tail
    entities.unshift @input.join
    @input.clear
    @tail = entities.pop # : String
  end

  def rejoin_split_delimiter(data)
    if @overlap.positive?
      tail_end = @tail[-@overlap..]
      @tail.slice!(-@overlap, @overlap)
      tail_end ? tail_end + data : data
    else
      data
    end
  end
end

# The expected constant for a gem named buftok
Buftok = BufferedTokenizer
