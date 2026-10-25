# frozen_string_literal: true

# Fixed inputs shared by the benchmarks, built in `once`. Every iteration
# ends on a delimiter (or a flush), so the tokenizer starts each iteration
# with an empty buffer and does the same work.

# A line of the given length, with no delimiter in it
def line(length) = ("a".."z").cycle.take(length).join

# A chunk of count lines, each ending with the delimiter
def lines(count, length: 80, delimiter: "\n") = (line(length) + delimiter) * count
