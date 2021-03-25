# frozen_string_literal: true
#
# Desipte the frozen_string_literal declaration, I'm leaving the explicit calls
# to .freeze to be extra clear about treating input as immutable.

require 'test/unit'
require 'buftok'

class TestBuftok < Test::Unit::TestCase
  def test_constant
    assert_same BufferedTokenizer, Buftok
  end

  def test_buftok
    tokenizer = BufferedTokenizer.new
    assert_equal %w[foo], tokenizer.extract("foo\nbar".freeze)
    assert_equal %w[barbaz qux], tokenizer.extract("baz\nqux\nquu".freeze)
    assert_equal 'quu', tokenizer.flush
    assert_equal '', tokenizer.flush
  end

  def test_delimiter
    tokenizer = BufferedTokenizer.new("<>".freeze)
    assert_equal ['', "foo\n"], tokenizer.extract("<>foo\n<>".freeze)
    assert_equal %w[bar], tokenizer.extract('bar<>baz'.freeze)
    assert_equal 'baz', tokenizer.flush
  end

  def test_split_delimiter
    tokenizer = BufferedTokenizer.new('<>'.freeze)
    assert_equal [], tokenizer.extract('foo<'.freeze)
    assert_equal %w[foo], tokenizer.extract('>bar<'.freeze)
    assert_equal %w[bar<baz qux], tokenizer.extract('baz<>qux<>'.freeze)
    assert_equal '', tokenizer.flush
  end

  def test_size
    tokenizer = BufferedTokenizer.new('<>'.freeze)
    assert_equal [], tokenizer.extract('foo<'.freeze)
    assert_equal 4, tokenizer.size
    assert_equal %w[foo], tokenizer.extract('>bar<'.freeze)
    assert_equal 4, tokenizer.size
    assert_equal %w[bar<baz qux], tokenizer.extract('baz<>qux<>'.freeze)
    assert_equal 0, tokenizer.size
  end
end
