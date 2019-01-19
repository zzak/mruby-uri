class TestCommon < MTest::Unit::TestCase
  def setup
  end

  def teardown
  end

  def test_extract
    assert_equal(['http://example.com'],
		 URI.extract('http://example.com'))
    assert_equal(['http://example.com'],
		 URI.extract('(http://example.com)'))
    assert_equal(['http://example.com/foo)'],
		 URI.extract('(http://example.com/foo)'))
    assert_equal(['http://example.jphttp://example.jp'],
		 URI.extract('http://example.jphttp://example.jp'), "[ruby-list:36086]")
    assert_equal(['http://example.jphttp://example.jp'],
		 URI.extract('http://example.jphttp://example.jp', ['http']), "[ruby-list:36086]")
    #assert_equal(['http://', 'mailto:'].sort,
    #    	 URI.extract('ftp:// http:// mailto: https://', ['http', 'mailto']).sort)
    ## reported by Doug Kearns <djkea2@mugca.its.monash.edu.au>
    #assert_equal(['From:', 'mailto:xxx@xxx.xxx.xxx]'].sort,
    #    	 URI.extract('From: XXX [mailto:xxx@xxx.xxx.xxx]').sort)
  end

  def test_regexp
    assert_instance_of Regexp, URI.regexp
    assert_instance_of Regexp, URI.regexp(['http'])
    assert_equal URI.regexp, URI.regexp
    assert_equal 'http://', 'x http:// x'.slice(URI.regexp)
    assert_equal 'http://', 'x http:// x'.slice(URI.regexp(['http']))
    assert_equal 'http://', 'x http:// x ftp://'.slice(URI.regexp(['http']))
    assert_equal nil, 'http://'.slice(URI.regexp([]))
    assert_equal nil, ''.slice(URI.regexp)
    assert_equal nil, 'xxxx'.slice(URI.regexp)
    assert_equal nil, ':'.slice(URI.regexp)
    assert_equal 'From:', 'From:'.slice(URI.regexp)
  end

  def test_kernel_uri
    expected = URI.parse("http://www.ruby-lang.org/")
    assert_equal(expected, URI("http://www.ruby-lang.org/"))
    assert_equal(expected, Kernel::URI("http://www.ruby-lang.org/"))
    #assert_raise(NoMethodError) { Object.new.URI("http://www.ruby-lang.org/") }
  end

  def test_encode_www_form_component
    assert_equal("+%21%22%23%24%25%26%27%28%29*%2B%2C-.%2F09%3A%3B%3C%3D%3E%3F%40AZ%5B%5C%5D%5E_%60az%7B%7C%7D%7E",
                 URI.encode_www_form_component(" !\"\#$%&'()*+,-./09:;<=>?@AZ[\\]^_`az{|}~"))
    assert_equal("%00%01", URI.encode_www_form_component("\x00\x01"))
    assert_equal("%AA%FF", URI.encode_www_form_component("\xaa\xff"))
  end

  def test_decode_www_form_component
    assert_equal(" !\"\#$%&'()*+,-./09:;<=>?@AZ[\\]^_`az{|}~",
                 URI.decode_www_form_component(
                   "+%21%22%23%24%25%26%27%28%29*%2B%2C-.%2F09%3A%3B%3C%3D%3E%3F%40AZ%5B%5C%5D%5E_%60az%7B%7C%7D%7E"))
    assert_equal("\x00\x01", URI.decode_www_form_component("%00%01"))
    assert_equal("\xaa\xff", URI.decode_www_form_component("%AA%FF"))
  end

  def test_encode_www_form
    assert_equal("a=1", URI.encode_www_form("a" => "1"))
    assert_equal("a=1", URI.encode_www_form(a: 1))
    assert_equal("a=1", URI.encode_www_form([["a", "1"]]))
    assert_equal("a=1", URI.encode_www_form([[:a, 1]]))
    expected = "a=1&%E3%81%82=%E6%BC%A2"
    assert_equal(expected, URI.encode_www_form("a" => "1", 'あ' => '漢'))
    assert_equal(expected, URI.encode_www_form(a: 1, :'あ' => '漢'))
    assert_equal(expected, URI.encode_www_form([["a", "1"], ['あ', '漢']]))
    assert_equal(expected, URI.encode_www_form([[:a, 1], [:'あ', '漢']]))

    assert_equal('&', URI.encode_www_form([['', nil], ['', nil]]))
    assert_equal('&=', URI.encode_www_form([['', nil], ['', '']]))
    assert_equal('=&', URI.encode_www_form([['', ''], ['', nil]]))
    assert_equal('=&=', URI.encode_www_form([['', ''], ['', '']]))
    assert_equal('', URI.encode_www_form([['', nil]]))
    assert_equal('', URI.encode_www_form([]))
    assert_equal('=', URI.encode_www_form([['', '']]))
    assert_equal('a%26b=1&c=2%3B3&e=4', URI.encode_www_form([['a&b', '1'], ['c', '2;3'], ['e', '4']]))
    assert_equal('image&title&price', URI.encode_www_form([['image', nil], ['title', nil], ['price', nil]]))
    assert_equal("q=ruby&q=perl&lang=en", URI.encode_www_form("q" => ["ruby", "perl"], "lang" => "en"))
  end

  def test_decode_www_form
    assert_equal([["あ", "漢"]], URI.decode_www_form("%E3%81%82=%E6%BC%A2"))
    assert_equal([%w[a 1], %w[a 2]], URI.decode_www_form("a=1&a=2"))
    assert_equal([%w[a 1;a=2]], URI.decode_www_form("a=1;a=2"))
    assert_equal([%w[a 1], ['', ''], %w[a 2]], URI.decode_www_form("a=1&&a=2"))
    assert_equal([%w[?a 1], %w[a 2]], URI.decode_www_form("?a=1&a=2"))
    assert_equal([], URI.decode_www_form(""))
    assert_equal([%w[% 1]], URI.decode_www_form("%=1"))
    assert_equal([%w[a %]], URI.decode_www_form("a=%"))
    assert_equal([%w[a 1], %w[% 2]], URI.decode_www_form("a=1&%=2"))
    assert_equal([%w[a 1], %w[b %]], URI.decode_www_form("a=1&b=%"))
    assert_equal([['a', ''], ['b', '']], URI.decode_www_form("a&b"))
  end

  def test_escape
    assert_equal("http://example.com/?a=%09%0D", URI.escape("http://example.com/?a=\11\15"))
    assert_equal("@%3F@%21", URI.escape("@?@!", "!?"))
  end

  def test_unescape
    assert_equal("http://example.com/?a=\t\r", URI.unescape("http://example.com/?a=%09%0D"))
  end
end

MTest::Unit.new.run
