# BufferedTokenizer takes a delimiter upon instantiation, or acts line-based
# by default.  It allows input to be spoon-fed from some outside source which
# receives arbitrary length datagrams which may-or-may-not contain the token
# by which entities are delimited.  In this respect it's ideally paired with
# something like EventMachine (http://rubyeventmachine.com/).
class BufferedTokenizer
  # New BufferedTokenizers will operate on lines delimited by a delimiter,
  # which is by default the global input delimiter $/ ("\n").
  #
  # The input buffer is stored as an array.  This is by far the most efficient
  # approach given language constraints (in C a linked list would be a more
  # appropriate data structure).  Segments of input data are stored in a list
  # which is only joined when a token is reached, substantially reducing the
  # number of objects required for the operation.
  def self.new(delimiter = $/)
    if delimiter.length == 1
      CharTokenizer.new(delimiter)
    else
      PatternTokenizer.new(delimiter)
    end
  end

  class CharTokenizer
    # Use check_size = false to ignore the size limit raise.
    # This is used by PatternTokenizer which calls super(delimiter, false)
    def initialize(delimiter = $/, check_size = true)
      if check_size && delimiter.length > 1
        raise ArgumentError, "Delimiter length too long: #{delimiter.inspect}. BufferedTokenizer::CharTokenizer misses multi-char delimiters that span input chunks."
      end
      @delimiter = delimiter
      @input = []
    end

    # Extract takes an arbitrary string of input data and returns an array of
    # tokenized entities, provided there were any available to extract.  This
    # makes for easy processing of datagrams using a pattern like:
    #
    #   tokenizer.extract(data).map { |entity| Decode(entity) }.each do ...
    def extract(data)
      # Specifying -1 forces split to return "" if the token is at the end of
      # the string, meaning the last element is the start of the next chunk.
      entities = data.split(@delimiter, -1)
      @input << entities.shift

      if entities.empty?
        entities
      else
        entities.unshift @input.join

        # The last entity in the list is the beginning of the next untokenized data.
        @input.clear
        @input << entities.pop

        entities
      end
    end

    # Flush the contents of the input buffer, i.e. return the input buffer even though
    # a token has not yet been encountered
    def flush
      buffer = @input.join
      @input.clear
      buffer
    end
  end

  # Speed can be improved when the single char tokenizer
  # can operate without having to worry about tokens spanning
  # data chunk edges.
  class PatternTokenizer < CharTokenizer
    def initialize(delimiter=$/)
      super(delimiter, false)
      @tail = ''
      @trim = @delimiter.size - 1
    end

    def extract(data)
      entities = (@tail + data).split(@delimiter, -1)
      @tail = entities.shift
      if entities.empty?
        @input << @tail.slice!(0, @tail.size-@trim)
        entities
      else
        @input << @tail
        entities.unshift @input.join
        @input.clear
        @tail = entities.pop
        entities
      end
    end

    def flush
      buffer = super + @tail
      @tail = ""
      buffer
    end
  end
end
