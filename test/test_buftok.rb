require 'test/unit'
require 'buftok'

class TestBuftok < Test::Unit::TestCase
  def test_buftok
    tokenizer = BufferedTokenizer.new
    assert_equal %w[foo], tokenizer.extract("foo\nbar")
    assert_equal %w[barbaz qux], tokenizer.extract("baz\nqux\nquu")
    assert_equal 'quu', tokenizer.flush
    assert_equal '', tokenizer.flush
  end

  def test_delimiter
    tokenizer = BufferedTokenizer.new('<>')
    assert_equal ['', "foo\n"], tokenizer.extract("<>foo\n<>")
    assert_equal %w[bar], tokenizer.extract('bar<>baz')
    assert_equal 'baz', tokenizer.flush
  end

  def test_split_delimiter
    tokenizer = BufferedTokenizer.new('<>')
    assert_equal [], tokenizer.extract('foo<')
    assert_equal %w[foo], tokenizer.extract('>bar<')
    assert_equal %w[bar<baz qux], tokenizer.extract('baz<>qux<>')
    assert_equal '', tokenizer.flush
  end
end
