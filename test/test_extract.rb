# frozen_string_literal: true

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

# Tests for BufferedTokenizer#extract
class BufferedTokenizer::ExtractTest < Minitest::Test # rubocop:disable Style/ClassAndModuleChildren
  cover BufferedTokenizer

  def test_extract_with_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal %w[foo], tokenizer.extract("foo\nbar")
  end

  def test_extract_multiple_tokens
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo\nbar")

    assert_equal %w[barbaz qux], tokenizer.extract("baz\nqux\nquu")
  end

  def test_extract_custom_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal ["", "foo\n"], tokenizer.extract("<>foo\n<>")
  end

  def test_extract_custom_delimiter_subsequent
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("<>foo\n<>")

    assert_equal %w[bar], tokenizer.extract("bar<>baz")
  end

  def test_extract_split_delimiter_no_match
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("foo<")
  end

  def test_extract_split_delimiter_recombined
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo<")

    assert_equal %w[foo], tokenizer.extract(">bar<")
  end

  def test_extract_split_delimiter_final
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo<")
    tokenizer.extract(">bar<")

    assert_equal %w[bar<baz qux], tokenizer.extract("baz<>qux<>")
  end

  def test_extract_preserves_state
    tokenizer = BufferedTokenizer.new

    assert_equal [], tokenizer.extract("hel")
    assert_equal [], tokenizer.extract("lo")
    assert_equal %w[hello], tokenizer.extract("\n")
  end

  def test_extract_only_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal [""], tokenizer.extract("\n")
  end

  def test_extract_multiple_delimiters_in_a_row
    tokenizer = BufferedTokenizer.new

    assert_equal ["", ""], tokenizer.extract("\n\n")
  end

  def test_extract_default_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal %w[line1 line2], tokenizer.extract("line1\nline2\n")
  end

  def test_extract_single_char_delimiter
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal %w[hello], tokenizer.extract("hello\nworld")
  end

  def test_extract_single_char_no_trim
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal [], tokenizer.extract("hello")
    assert_equal %w[hello world], tokenizer.extract("\nworld\n")
  end

  def test_extract_three_char_delimiter
    tokenizer = BufferedTokenizer.new("|||")

    assert_equal [], tokenizer.extract("foo|")
    assert_equal [], tokenizer.extract("|")
    assert_equal %w[foo], tokenizer.extract("|bar")
  end

  def test_extract_two_char_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal %w[ab cd], tokenizer.extract("ab<>cd<>")
  end

  def test_extract_recombines_correctly
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("x<")
    assert_equal %w[x], tokenizer.extract(">y<")
    assert_equal %w[y], tokenizer.extract(">")
  end

  def test_extract_single_char_no_spurious_slice
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal [], tokenizer.extract("ab")
    assert_equal %w[ab], tokenizer.extract("\n")
  end

  def test_extract_trim_zero_does_not_corrupt
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal %w[abc], tokenizer.extract("abc\ndef")
    assert_equal %w[def], tokenizer.extract("\n")
  end

  def test_extract_initializer_default_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal %w[a], tokenizer.extract("a\nb")
  end
end
