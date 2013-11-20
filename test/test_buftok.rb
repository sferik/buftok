require 'test/unit'
require 'buftok'

class TestBuftok < Test::Unit::TestCase
  def test_buftok
    tokenizer = BufferedTokenizer.new
    assert_equal(tokenizer.extract("foo\nbar"), %w[foo])
    assert_equal(tokenizer.extract("baz\nqux\nquu"), %w[barbaz qux])
    assert_equal(tokenizer.flush, 'quu')
    assert_equal(tokenizer.flush, '')
  end

  def test_delimiter
    tokenizer = BufferedTokenizer.new('<>')
    assert_equal(tokenizer.extract("<>foo\n<>"), ['', "foo\n"])
    assert_equal(tokenizer.extract('bar<>baz'), %w[bar])
    assert_equal(tokenizer.flush, 'baz')
  end

  def test_split_delimiter
    tokenizer = BufferedTokenizer.new('<>')
    assert_equal(tokenizer.extract('foo<'), [])
    assert_equal(tokenizer.extract('>bar<'), %w[foo])
    assert_equal(tokenizer.extract('baz<>qux<>'), %w[bar<baz qux])
    assert_equal(tokenizer.flush, '')
  end
end
