# frozen_string_literal: true

require_relative "duel_helper"

# Single-character delimiter (the default "\n")

duel "extract: one short line" do
  once do
    @tokenizer = BufferedTokenizer.new
    @chunk = "hello\n"
  end
  @tokenizer.extract(@chunk)
end

duel "extract: 100 lines in an 8 KB chunk" do
  once do
    @tokenizer = BufferedTokenizer.new
    @chunk = lines(100)
  end
  @tokenizer.extract(@chunk)
end

duel "extract: 1,000 lines in a 64 KB chunk" do
  once do
    @tokenizer = BufferedTokenizer.new
    @chunk = lines(1_000, length: 64)
  end
  @tokenizer.extract(@chunk)
end

duel "extract: a line over 100 chunks" do
  once do
    @tokenizer = BufferedTokenizer.new
    @chunks = Array.new(100) { line(80) } << "\n"
  end
  @chunks.each { |chunk| @tokenizer.extract(chunk) }
end

# Multi-character delimiter

duel "extract: 100 CRLF lines in a chunk" do
  once do
    @tokenizer = BufferedTokenizer.new("\r\n")
    @chunk = lines(100, delimiter: "\r\n")
  end
  @tokenizer.extract(@chunk)
end

duel "extract: CRLF split across 100 chunks" do
  once do
    @tokenizer = BufferedTokenizer.new("\r\n")
    # Each chunk ends with "\r" and the next starts with "\n"
    @chunks = ["#{line(80)}\r"]
    99.times { @chunks << "\n#{line(80)}\r" }
    @chunks << "\n"
  end
  @chunks.each { |chunk| @tokenizer.extract(chunk) }
end

duel "extract: a CRLF line over 100 chunks" do
  once do
    @tokenizer = BufferedTokenizer.new("\r\n")
    @chunks = Array.new(100) { line(80) } << "\r\n"
  end
  @chunks.each { |chunk| @tokenizer.extract(chunk) }
end
