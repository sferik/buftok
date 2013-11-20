# BufferedTokenizer takes a delimiter upon instantiation, or acts line-based
# by default.  It allows input to be spoon-fed from some outside source which
# receives arbitrary length datagrams which may-or-may-not contain the token
# by which entities are delimited.  In this respect it's ideally paired with
# something like EventMachine (http://rubyforge.org/projects/eventmachine).
class BufferedTokenizer
  # New BufferedTokenizers will operate on lines delimited by "\n" by default
  # or allow you to specify any delimiter token you so choose, which will then
  # be used by String#split to tokenize the input data.
  def initialize(delimiter = "\n")
    # Store the specified delimiter
    @delimiter = delimiter

    # The input buffer is stored as an array.  This is by far the most efficient
    # approach given language constraints (in C a linked list would be a more
    # appropriate data structure).  Segments of input data are stored in a list
    # which is only joined when a token is reached, substantially reducing the
    # number of objects required for the operation.
    @input = []
  end

  # Extract takes an arbitrary string of input data and returns an array of
  # tokenized entities, provided there were any available to extract.  This
  # makes for easy processing of datagrams using a pattern like:
  #
  #   tokenizer.extract(data).map { |entity| Decode(entity) }.each do ...
  def extract(data)
    # Extract token-delimited entities from the input string with the split command.
    # There's a bit of craftiness here with the -1 parameter.  Normally split would
    # behave no differently regardless of if the token lies at the very end of the
    # input buffer or not (i.e. a literal edge case)  Specifying -1 forces split to
    # return "" in this case, meaning that the last entry in the list represents a
    # new segment of data where the token has not been encountered.
    entities = data.split @delimiter, -1

    # Move the first entry in the resulting array into the input buffer.  It represents
    # the last segment of a token-delimited entity unless it's the only entry in the list.
    @input << entities.shift

    # If the resulting array from the split is empty, the token was not encountered
    # (not even at the end of the buffer).  Since we've encountered no token-delimited
    # entities this go-around, return an empty array.
    return [] if entities.empty?

    # At this point, we've hit a token, or potentially multiple tokens.  Now we can bring
    # together all the data we've buffered from earlier calls without hitting a token,
    # and add it to our list of discovered entities.
    entities.unshift @input.join

    # Now that we've hit a token, joined the input buffer and added it to the entities
    # list, we can go ahead and clear the input buffer.  All of the segments that were
    # stored before the join can now be garbage collected.
    @input.clear

    # The last entity in the list is not token delimited, however, thanks to the -1
    # passed to split.  It represents the beginning of a new list of as-yet-untokenized
    # data, so we add it to the start of the list.
    @input << entities.pop

    # Now we're left with the list of extracted token-delimited entities we wanted
    # in the first place.  Hooray!
    entities
  end

  # Flush the contents of the input buffer, i.e. return the input buffer even though
  # a token has not yet been encountered
  def flush
    buffer = @input.join
    @input.clear
    buffer
  end
end
