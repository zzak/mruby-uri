# = uri/common.rb
#
# Author:: Akira Yamada <akira@ruby-lang.org>
# Revision:: $Id$
# License::
#   You can redistribute it and/or modify it under the same term as Ruby.
#

module URI
  REGEXP = RFC2396_REGEXP
  Parser = RFC2396_Parser
  RFC3986_PARSER = RFC3986_Parser.new

  # URI::Parser.new
  DEFAULT_PARSER = Parser.new
  DEFAULT_PARSER.pattern.each do |sym, str|
    unless REGEXP::PATTERN.const_defined?(sym)
      REGEXP::PATTERN.const_set(sym, str)
    end
  end
  DEFAULT_PARSER.regexp.each do |sym, str|
    const_set(sym, str)
  end

  module Util # :nodoc:
    def make_components_hash(klass, array_hash)
      tmp = {}
      if array_hash.kind_of?(Array) &&
          array_hash.size == klass.component.size - 1
        klass.component[1..-1].each_index do |i|
          begin
            tmp[klass.component[i + 1]] = array_hash[i].clone
          rescue TypeError
            tmp[klass.component[i + 1]] = array_hash[i]
          end
        end

      elsif array_hash.kind_of?(Hash)
        array_hash.each do |key, value|
          begin
            tmp[key] = value.clone
          rescue TypeError
            tmp[key] = value
          end
        end
      else
        raise ArgumentError,
          "expected Array of or Hash of components of #{klass.to_s} (#{klass.component[1..-1].join(', ')})"
      end
      tmp[:scheme] = klass.to_s.sub(/\A.*::/, '').downcase

      return tmp
    end
    module_function :make_components_hash
  end

  module Escape
    include REGEXP

    #
    # == Synopsis
    #
    #   URI.escape(str [, unsafe])
    #
    # == Args
    #
    # +str+::
    #   String to replaces in.
    # +unsafe+::
    #   Regexp that matches all symbols that must be replaced with codes.
    #   By default uses <tt>REGEXP::UNSAFE</tt>.
    #   When this argument is a String, it represents a character set.
    #
    # == Description
    #
    # Escapes the string, replacing all unsafe characters with codes.
    #
    # == Usage
    #
    #   require 'uri'
    #
    #   enc_uri = URI.escape("http://example.com/?a=\11\15")
    #   p enc_uri
    #   # => "http://example.com/?a=%09%0D"
    #
    #   p URI.unescape(enc_uri)
    #   # => "http://example.com/?a=\t\r"
    #
    #   p URI.escape("@?@!", "!?")
    #   # => "@%3F@%21"
    #
    def escape(str, unsafe = UNSAFE)
      # URI.escape is obsolete"
      DEFAULT_PARSER.escape(*arg)
    end
    alias encode escape
    #
    # == Synopsis
    #
    #   URI.unescape(str)
    #
    # == Args
    #
    # +str+::
    #   Unescapes the string.
    #
    # == Usage
    #
    #   require 'uri'
    #
    #   enc_uri = URI.escape("http://example.com/?a=\11\15")
    #   p enc_uri
    #   # => "http://example.com/?a=%09%0D"
    #
    #   p URI.unescape(enc_uri)
    #   # => "http://example.com/?a=\t\r"
    #
    def unescape(str)
      # URI.unescape is obsolete
      DEFAULT_PARSER.unescape(*arg)
    end
    alias decode unescape
  end

  include REGEXP
  extend Escape

  @@schemes = {}
  # Returns a Hash of the defined schemes
  def self.scheme_list
    @@schemes
  end

  #
  # Base class for all URI exceptions.
  #
  class Error < StandardError; end
  #
  # Not a URI.
  #
  class InvalidURIError < Error; end
  #
  # Not a URI component.
  #
  class InvalidComponentError < Error; end
  #
  # URI is valid, bad usage is not.
  #
  class BadURIError < Error; end

  #
  # == Synopsis
  #
  #   URI::split(uri)
  #
  # == Args
  #
  # +uri+::
  #   String with URI.
  #
  # == Description
  #
  # Splits the string on following parts and returns array with result:
  #
  #   * Scheme
  #   * Userinfo
  #   * Host
  #   * Port
  #   * Registry
  #   * Path
  #   * Opaque
  #   * Query
  #   * Fragment
  #
  # == Usage
  #
  #   require 'uri'
  #
  #   p URI.split("http://www.ruby-lang.org/")
  #   # => ["http", nil, "www.ruby-lang.org", nil, nil, "/", nil, nil, nil]
  #
  def self.split(uri)
    RFC3986_PARSER.split(uri)
  end

  #
  # == Synopsis
  #
  #   URI::parse(uri_str)
  #
  # == Args
  #
  # +uri_str+::
  #   String with URI.
  #
  # == Description
  #
  # Creates one of the URI's subclasses instance from the string.
  #
  # == Raises
  #
  # URI::InvalidURIError
  #   Raised if URI given is not a correct one.
  #
  # == Usage
  #
  #   require 'uri'
  #
  #   uri = URI.parse("http://www.ruby-lang.org/")
  #   p uri
  #   # => #<URI::HTTP:0x202281be URL:http://www.ruby-lang.org/>
  #   p uri.scheme
  #   # => "http"
  #   p uri.host
  #   # => "www.ruby-lang.org"
  #
  def self.parse(uri)
    RFC3986_PARSER.parse(uri)
  end

  #
  # == Synopsis
  #
  #   URI::join(str[, str, ...])
  #
  # == Args
  #
  # +str+::
  #   String(s) to work with
  #
  # == Description
  #
  # Joins URIs.
  #
  # == Usage
  #
  #   require 'uri'
  #
  #   p URI.join("http://localhost/","main.rbx")
  #   # => #<URI::HTTP:0x2022ac02 URL:http://localhost/main.rbx>
  #
  def self.join(*str)
    RFC3986_PARSER.join(*str)
  end

  #
  # == Synopsis
  #
  #   URI::extract(str[, schemes][,&blk])
  #
  # == Args
  #
  # +str+::
  #   String to extract URIs from.
  # +schemes+::
  #   Limit URI matching to a specific schemes.
  #
  # == Description
  #
  # Extracts URIs from a string. If block given, iterates through all matched URIs.
  # Returns nil if block given or array with matches.
  #
  # == Usage
  #
  #   require "uri"
  #
  #   URI.extract("text here http://foo.example.org/bla and here mailto:test@example.com and here also.")
  #   # => ["http://foo.example.com/bla", "mailto:test@example.com"]
  #
  def self.extract(str, schemes = nil, &block)
    # URI.extract is obsolete
    DEFAULT_PARSER.extract(str, schemes, &block)
  end


  #
  # == Synopsis
  #
  #   URI::regexp([match_schemes])
  #
  # == Args
  #
  # +match_schemes+::
  #   Array of schemes. If given, resulting regexp matches to URIs
  #   whose scheme is one of the match_schemes.
  #
  # == Description
  # Returns a Regexp object which matches to URI-like strings.
  # The Regexp object returned by this method includes arbitrary
  # number of capture group (parentheses).  Never rely on it's number.
  #
  # == Usage
  #
  #   require 'uri'
  #
  #   # extract first URI from html_string
  #   html_string.slice(URI.regexp)
  #
  #   # remove ftp URIs
  #   html_string.sub(URI.regexp(['ftp'])
  #
  #   # You should not rely on the number of parentheses
  #   html_string.scan(URI.regexp) do |*matches|
  #     p $&
  #   end
  #
  def self.regexp(schemes = nil)
    # URI.regexp is obsolete
    DEFAULT_PARSER.make_regexp(schemes)
  end

  # :nodoc:
  TBLENCWWWCOMP_ = {}
  256.times do |i|
    TBLENCWWWCOMP_[i.chr] = '%%%02X' % i
  end
  TBLENCWWWCOMP_[' '] = '+'

  # :nodoc:
  TBLDECWWWCOMP_ = {}
  256.times do |i|
    h, l = i>>4, i&15
    TBLDECWWWCOMP_['%%%X%X' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%x%X' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%X%x' % [h, l]] = i.chr
    TBLDECWWWCOMP_['%%%x%x' % [h, l]] = i.chr
  end
  TBLDECWWWCOMP_['+'] = ' '

  # Encode given +str+ to URL-encoded form data.
  #
  # This doesn't convert *, -, ., 0-9, A-Z, _, a-z,
  # does convert SP to +, and convert others to %XX.
  #
  # This refers http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
  #
  # See URI.decode_www_form_component(str), URI.encode_www_form(enum)
  def self.encode_www_form_component(str)
    str.to_s.gsub(/[^*\-.0-9A-Z_a-z]/n) { TBLENCWWWCOMP_[$&] }
  end

  # Decode given +str+ of URL-encoded form data.
  #
  # This decods + to SP.
  #
  # See URI.encode_www_form_component(str)
  def self.decode_www_form_component(str)
    str.gsub(/\+|%\h\h/){ TBLDECWWWCOMP_[$&] }
  end

  # Generate URL-encoded form data from given +enum+.
  #
  # This generates application/x-www-form-urlencoded data defined in HTML5
  # from given an Enumerable object.
  #
  # This internally uses URI.encode_www_form_component(str).
  #
  # This doesn't convert encodings of give items, so convert them before call
  # this method if you want to send data as other than original encoding or
  # mixed encoding data.
  #
  # This doesn't treat files. When you send a file, use multipart/form-data.
  #
  # This refers http://www.w3.org/TR/html5/forms.html#url-encoded-form-data
  #
  # See URI.encode_www_form_component(str)
  def self.encode_www_form(enum)
    enum.map do |k, v|
      if v.nil?
        encode_www_form_component(k)
      elsif v.respond_to?(:to_a)
        v.to_a.map do |w|
          str = encode_www_form_component(k)
          unless w.nil?
            str << '='
            str << encode_www_form_component(w)
          end
        end.join('&')
      else
        str = encode_www_form_component(k)
        str << '='
        str << encode_www_form_component(v)
      end
    end.join("&")
  end

  def self.decode_www_form(str, opts = {})
    separator = opts[:separator] || '&'
    ary = []
    return ary if str.empty?
    str.split(separator).map do |string|
      key, val = string.split('=', 2)

      [
        key.nil? ? "" : decode_www_form_component(key),
        val.nil? ? "" : decode_www_form_component(val),
      ]
    end
  end
end

module Kernel
  # alias for URI.parse.
  #
  # This method is introduced at 1.8.2.
  def URI(uri_str) # :doc:
    URI.parse(uri_str)
  end
  module_function :URI
end
