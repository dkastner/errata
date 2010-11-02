require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'errata'))

class Test::Unit::TestCase
  def utf8_text
    file = File.read File.expand_path('utf8.txt', File.dirname(__FILE__))
    file.split("\n").first
  end

  def ascii_8bit_regex
    file = File.read(File.expand_path('ascii_8bit.regex', File.dirname(__FILE__))).force_encoding 'ASCII-8BIT'
    file.split("\n").first
  end
end
