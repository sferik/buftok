# frozen_string_literal: true

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

# Tests for BufferedTokenizer#size and internal buffer state
class BufferedTokenizer
  class SizeTest < Minitest::Test
    cover BufferedTokenizer

    def test_zero_initially
      assert_equal 0, BufferedTokenizer.new.size
    end

    def test_after_partial_input
      tokenizer = BufferedTokenizer.new
      tokenizer.extract("foo")

      assert_equal 3, tokenizer.size
    end

    def test_accumulates_across_extracts
      tokenizer = BufferedTokenizer.new
      tokenizer.extract("foo")
      tokenizer.extract("bar")

      assert_equal 6, tokenizer.size
    end

    def test_includes_partial_delimiter
      tokenizer = BufferedTokenizer.new("<>")
      tokenizer.extract("foo<")

      assert_equal 4, tokenizer.size
    end

    def test_after_token_found
      tokenizer = BufferedTokenizer.new("<>")
      tokenizer.extract("foo<")
      tokenizer.extract(">bar<")

      assert_equal 4, tokenizer.size
    end

    def test_zero_after_complete_tokens
      tokenizer = BufferedTokenizer.new("<>")
      tokenizer.extract("foo<")
      tokenizer.extract(">bar<")
      tokenizer.extract("baz<>qux<>")

      assert_equal 0, tokenizer.size
    end

    def test_input_buffer_grows_without_delimiter
      tokenizer = BufferedTokenizer.new
      tokenizer.extract("abc")

      assert_equal 1, tokenizer.instance_variable_get(:@input).length
    end

    def test_input_buffer_accumulates
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

    def test_single_char_delimiter_preserves_tail_in_input
      tokenizer = BufferedTokenizer.new("\n")
      tokenizer.extract("abc")
      tail_before = tokenizer.instance_variable_get(:@tail).dup
      tokenizer.extract("def")

      assert_includes tokenizer.instance_variable_get(:@input), tail_before
    end
  end
end
