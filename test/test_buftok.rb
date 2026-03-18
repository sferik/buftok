# frozen_string_literal: true

#
# Despite the frozen_string_literal declaration, I'm leaving the explicit calls
# to .freeze to be extra clear about treating input as immutable.

require "minitest/autorun"
require "mutant/minitest/coverage"
require "buftok"

class BufferedTokenizer::Test < Minitest::Test # rubocop:disable Style/ClassAndModuleChildren
  cover BufferedTokenizer

  def test_constant
    assert_same BufferedTokenizer, Buftok
  end

  def test_buftok
    tokenizer = BufferedTokenizer.new

    assert_equal %w[foo], tokenizer.extract("foo\nbar")
    assert_equal %w[barbaz qux], tokenizer.extract("baz\nqux\nquu")
    assert_equal "quu", tokenizer.flush
    assert_equal "", tokenizer.flush
  end

  def test_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal ["", "foo\n"], tokenizer.extract("<>foo\n<>")
    assert_equal %w[bar], tokenizer.extract("bar<>baz")
    assert_equal "baz", tokenizer.flush
  end

  def test_split_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("foo<")
    assert_equal %w[foo], tokenizer.extract(">bar<")
    assert_equal %w[bar<baz qux], tokenizer.extract("baz<>qux<>")
    assert_equal "", tokenizer.flush
  end

  def test_size
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("foo<")
    assert_equal 4, tokenizer.size
    assert_equal %w[foo], tokenizer.extract(">bar<")
    assert_equal 4, tokenizer.size
    assert_equal %w[bar<baz qux], tokenizer.extract("baz<>qux<>")
    assert_equal 0, tokenizer.size
  end

  def test_size_with_buffered_input
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")

    assert_equal 3, tokenizer.size

    tokenizer.extract("bar")

    assert_equal 6, tokenizer.size
  end

  def test_single_char_delimiter
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal %w[hello], tokenizer.extract("hello\nworld")
    assert_equal "world", tokenizer.flush
  end

  def test_single_char_delimiter_no_trim
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal [], tokenizer.extract("hello")
    assert_equal %w[hello world], tokenizer.extract("\nworld\n")
    assert_equal "", tokenizer.flush
  end

  def test_extract_preserves_state_across_calls
    tokenizer = BufferedTokenizer.new

    assert_equal [], tokenizer.extract("hel")
    assert_equal [], tokenizer.extract("lo")
    assert_equal %w[hello], tokenizer.extract("\n")
    assert_equal "", tokenizer.flush
  end

  def test_extract_only_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal [""], tokenizer.extract("\n")
    assert_equal "", tokenizer.flush
  end

  def test_flush_empty
    tokenizer = BufferedTokenizer.new

    assert_equal "", tokenizer.flush
  end

  def test_multiple_delimiters_in_a_row
    tokenizer = BufferedTokenizer.new

    assert_equal ["", ""], tokenizer.extract("\n\n")
    assert_equal "", tokenizer.flush
  end

  def test_split_delimiter_boundary
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("a<")
    assert_equal 2, tokenizer.size
    assert_equal %w[a], tokenizer.extract(">b")
    assert_equal "b", tokenizer.flush
  end

  def test_default_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal %w[line1 line2], tokenizer.extract("line1\nline2\n")
    assert_equal "", tokenizer.flush
  end

  def test_three_char_delimiter
    tokenizer = BufferedTokenizer.new("|||")

    assert_equal [], tokenizer.extract("foo|")
    assert_equal [], tokenizer.extract("|")
    assert_equal %w[foo], tokenizer.extract("|bar")
    assert_equal "bar", tokenizer.flush
  end

  def test_single_char_no_spurious_slice
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal [], tokenizer.extract("ab")
    assert_equal %w[ab], tokenizer.extract("\n")
    assert_equal "", tokenizer.flush
  end

  def test_trim_zero_does_not_corrupt
    tokenizer = BufferedTokenizer.new("\n")

    assert_equal %w[abc], tokenizer.extract("abc\ndef")
    assert_equal %w[def], tokenizer.extract("\n")
  end

  def test_two_char_delimiter_trim_correctness
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal %w[ab cd], tokenizer.extract("ab<>cd<>")
    assert_equal "", tokenizer.flush
  end

  def test_initializer_default_delimiter
    tokenizer = BufferedTokenizer.new

    assert_equal %w[a], tokenizer.extract("a\nb")
    assert_equal "b", tokenizer.flush
  end

  def test_split_delimiter_recombines_correctly
    tokenizer = BufferedTokenizer.new("<>")

    assert_equal [], tokenizer.extract("x<")
    assert_equal %w[x], tokenizer.extract(">y<")
    assert_equal %w[y], tokenizer.extract(">")
    assert_equal "", tokenizer.flush
  end

  def test_flush_resets_state
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("foo")

    assert_equal "foo", tokenizer.flush
    assert_equal %w[bar], tokenizer.extract("bar\nbaz")
    assert_equal "baz", tokenizer.flush
  end

  def test_flush_clears_input_buffer
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("abc")

    assert_equal "abc", tokenizer.flush
    tokenizer.extract("xyz")

    assert_equal "xyz", tokenizer.flush
  end

  def test_double_flush
    tokenizer = BufferedTokenizer.new

    tokenizer.extract("data")

    assert_equal "data", tokenizer.flush
    assert_equal "", tokenizer.flush
    assert_equal 0, tokenizer.size
  end

  def test_flush_then_extract_with_multichar_delimiter
    tokenizer = BufferedTokenizer.new("<>")

    tokenizer.extract("foo")
    tokenizer.flush

    assert_equal %w[bar], tokenizer.extract("bar<>baz")
    assert_equal "baz", tokenizer.flush
  end

  def test_respects_custom_record_separator
    old_sep = $/
    $/ = ","
    tokenizer = BufferedTokenizer.new

    assert_equal %w[a], tokenizer.extract("a,b")
    assert_equal "b", tokenizer.flush
  ensure
    $/ = old_sep
  end

  def test_default_with_nil_record_separator
    old_sep = $/
    $/ = nil
    tokenizer = BufferedTokenizer.new

    assert_equal %w[a], tokenizer.extract("a\nb")
    assert_equal "b", tokenizer.flush
  ensure
    $/ = old_sep
  end

  def test_split_limit
    assert_equal(-1, BufferedTokenizer::SPLIT_LIMIT)
  end

  def test_overlap_value
    assert_equal 0, BufferedTokenizer.new("\n").overlap
    assert_equal 1, BufferedTokenizer.new("<>").overlap
    assert_equal 2, BufferedTokenizer.new("|||").overlap
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
    # With single-char delimiter, rejoin should not modify @tail via slice
    # The old @tail should appear intact in @input
    input = tokenizer.instance_variable_get(:@input)

    assert_includes input, tail_before
  end
end
