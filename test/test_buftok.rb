# frozen_string_literal: true

#
# Despite the frozen_string_literal declaration, I'm leaving the explicit calls
# to .freeze to be extra clear about treating input as immutable.

require "minitest/autorun"
require "buftok"

class TestBuftok < Minitest::Test
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
end
