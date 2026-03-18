# frozen_string_literal: true

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

# Tests for BufferedTokenizer#flush
class BufferedTokenizer::FlushTest < Minitest::Test # rubocop:disable Style/ClassAndModuleChildren
  cover BufferedTokenizer

  def test_flush_empty
    assert_equal "", BufferedTokenizer.new.flush
  end

  def test_flush_returns_buffered_data
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")

    assert_equal "abc", tokenizer.flush
  end

  def test_flush_returns_empty_after_complete_token
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc\n")

    assert_equal "", tokenizer.flush
  end

  def test_flush_returns_remainder
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc\ndef")

    assert_equal "def", tokenizer.flush
  end

  def test_flush_custom_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("bar<>baz")

    assert_equal "baz", tokenizer.flush
  end

  def test_consecutive_flush_returns_empty
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("data")
    tokenizer.flush

    assert_equal "", tokenizer.flush
  end

  def test_flush_resets_for_subsequent_extract
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")
    tokenizer.flush

    assert_equal %w[bar], tokenizer.extract("bar\nbaz")
  end

  def test_flush_resets_for_subsequent_flush
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")
    tokenizer.flush
    tokenizer.extract("bar\nbaz")

    assert_equal "baz", tokenizer.flush
  end

  def test_flush_clears_input_buffer
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")
    tokenizer.flush
    tokenizer.extract("xyz")

    assert_equal "xyz", tokenizer.flush
  end

  def test_flush_size_zero_after_double_flush
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("data")
    tokenizer.flush
    tokenizer.flush

    assert_equal 0, tokenizer.size
  end

  def test_flush_then_extract_with_multichar_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo")
    tokenizer.flush

    assert_equal %w[bar], tokenizer.extract("bar<>baz")
  end

  def test_flush_then_flush_with_multichar_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo")
    tokenizer.flush
    tokenizer.extract("bar<>baz")

    assert_equal "baz", tokenizer.flush
  end
end
