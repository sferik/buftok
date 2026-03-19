# frozen_string_literal: true

require_relative "test_helper"

class BufferedTokenizer
  class InitTest < Minitest::Test
    cover BufferedTokenizer

    def test_buftok_alias
      assert_same BufferedTokenizer, Buftok
    end

    def test_split_limit_constant
      assert_equal(-1, BufferedTokenizer::SPLIT_LIMIT)
    end

    def test_default_delimiter_is_newline
      tokenizer = BufferedTokenizer.new

      assert_equal %w[a], tokenizer.extract("a\nb")
      assert_equal "b", tokenizer.flush
    end

    def test_custom_delimiter
      tokenizer = BufferedTokenizer.new(",")

      assert_equal %w[a], tokenizer.extract("a,b")
      assert_equal "b", tokenizer.flush
    end

    def test_overlap_for_single_char_delimiter
      assert_equal 0, BufferedTokenizer.new("\n").overlap
    end

    def test_overlap_for_two_char_delimiter
      assert_equal 1, BufferedTokenizer.new("<>").overlap
    end

    def test_overlap_for_three_char_delimiter
      assert_equal 2, BufferedTokenizer.new("|||").overlap
    end
  end
end
