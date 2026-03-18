# frozen_string_literal: true

require "English"
require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

# Tests for BufferedTokenizer initialization, size, constants, and internal state
class BufferedTokenizer::Test < Minitest::Test # rubocop:disable Style/ClassAndModuleChildren
  cover BufferedTokenizer

  def test_constant
    assert_same BufferedTokenizer, Buftok
  end

  def test_split_limit
    assert_equal(-1, BufferedTokenizer::SPLIT_LIMIT)
  end

  def test_overlap_single_char
    assert_equal 0, BufferedTokenizer.new("\n").overlap
  end

  def test_overlap_two_char
    assert_equal 1, BufferedTokenizer.new("<>").overlap
  end

  def test_overlap_three_char
    assert_equal 2, BufferedTokenizer.new("|||").overlap
  end

  def test_size_after_extract_no_delimiter
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")

    assert_equal 3, tokenizer.size
  end

  def test_size_accumulates_without_delimiter
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")
    tokenizer.extract("bar")

    assert_equal 6, tokenizer.size
  end

  def test_size_with_split_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo<")

    assert_equal 4, tokenizer.size
  end

  def test_size_after_token_found
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo<")
    tokenizer.extract(">bar<")

    assert_equal 4, tokenizer.size
  end

  def test_size_after_complete_tokens
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo<")
    tokenizer.extract(">bar<")
    tokenizer.extract("baz<>qux<>")

    assert_equal 0, tokenizer.size
  end

  def test_input_buffer_state_without_delimiter
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")

    assert_equal 1, tokenizer.instance_variable_get(:@input).length
  end

  def test_input_buffer_accumulates_without_delimiter
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")
    tokenizer.extract("def")

    assert_equal 2, tokenizer.instance_variable_get(:@input).length
  end

  def test_input_buffer_clears_on_delimiter
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")
    tokenizer.extract("def\nghi")

    assert_empty tokenizer.instance_variable_get(:@input)
  end

  def test_single_char_delimiter_does_not_slice_tail
    tokenizer = BufferedTokenizer.new("\n")

    tokenizer.extract("abc")
    tail_before = tokenizer.instance_variable_get(:@tail).dup
    tokenizer.extract("def")
    input = tokenizer.instance_variable_get(:@input)

    assert_includes input, tail_before
  end

  def test_respects_custom_delimiter
    tokenizer = BufferedTokenizer.new(",")

    assert_equal %w[a], tokenizer.extract("a,b")
    assert_equal "b", tokenizer.flush
  end

  def test_default_delimiter_is_newline
    tokenizer = BufferedTokenizer.new

    assert_equal %w[a], tokenizer.extract("a\nb")
    assert_equal "b", tokenizer.flush
  end
end
