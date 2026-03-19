# frozen_string_literal: true

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

# Tests for BufferedTokenizer#extract
class BufferedTokenizer
  class ExtractTest < Minitest::Test
    cover BufferedTokenizer

    def test_returns_complete_tokens
      tokenizer = BufferedTokenizer.new

      assert_equal %w[foo], tokenizer.extract("foo\nbar")
    end

    def test_returns_multiple_tokens
      tokenizer = BufferedTokenizer.new

      assert_equal %w[foo bar], tokenizer.extract("foo\nbar\nbaz")
    end

    def test_buffers_partial_input
      tokenizer = BufferedTokenizer.new

      assert_equal [], tokenizer.extract("hel")
      assert_equal [], tokenizer.extract("lo")
      assert_equal %w[hello], tokenizer.extract("\n")
    end

    def test_joins_buffered_input_with_first_token
      tokenizer = BufferedTokenizer.new
      tokenizer.extract("foo\nbar")

      assert_equal %w[barbaz qux], tokenizer.extract("baz\nqux\nquu")
    end

    def test_only_delimiter
      assert_equal [""], BufferedTokenizer.new.extract("\n")
    end

    def test_consecutive_delimiters
      assert_equal ["", ""], BufferedTokenizer.new.extract("\n\n")
    end

    def test_trailing_delimiter
      assert_equal %w[line1 line2], BufferedTokenizer.new.extract("line1\nline2\n")
    end

    def test_two_char_delimiter
      tokenizer = BufferedTokenizer.new("<>")

      assert_equal ["", "foo\n"], tokenizer.extract("<>foo\n<>")
    end

    def test_two_char_delimiter_multiple_tokens
      assert_equal %w[ab cd], BufferedTokenizer.new("<>").extract("ab<>cd<>")
    end

    def test_two_char_delimiter_subsequent_chunk
      tokenizer = BufferedTokenizer.new("<>")
      tokenizer.extract("<>foo\n<>")

      assert_equal %w[bar], tokenizer.extract("bar<>baz")
    end

    def test_three_char_delimiter_split_across_chunks
      tokenizer = BufferedTokenizer.new("|||")

      assert_equal [], tokenizer.extract("foo|")
      assert_equal [], tokenizer.extract("|")
      assert_equal %w[foo], tokenizer.extract("|bar")
    end

    def test_split_delimiter_recombines
      tokenizer = BufferedTokenizer.new("<>")

      assert_equal [], tokenizer.extract("foo<")
      assert_equal %w[foo], tokenizer.extract(">bar<")
      assert_equal %w[bar<baz qux], tokenizer.extract("baz<>qux<>")
    end

    def test_split_delimiter_across_multiple_chunks
      tokenizer = BufferedTokenizer.new("<>")

      assert_equal [], tokenizer.extract("x<")
      assert_equal %w[x], tokenizer.extract(">y<")
      assert_equal %w[y], tokenizer.extract(">")
    end

    def test_single_char_delimiter_does_not_slice
      tokenizer = BufferedTokenizer.new("\n")

      assert_equal [], tokenizer.extract("ab")
      assert_equal %w[ab], tokenizer.extract("\n")
    end

    def test_single_char_delimiter_preserves_data
      tokenizer = BufferedTokenizer.new("\n")

      assert_equal %w[abc], tokenizer.extract("abc\ndef")
      assert_equal %w[def], tokenizer.extract("\n")
    end
  end
end
