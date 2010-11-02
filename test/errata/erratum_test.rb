require 'test_helper'

class Errata::ErratumTest < Test::Unit::TestCase
  context 'expression_matches?' do
    setup do
      errata = nil
      @erratum = Errata::Erratum.new errata, :section => 0
    end

    should 'return true for an empty matching_expression' do
      @erratum.set_matching_expression :x => nil
      assert @erratum.expression_matches?(['fooble'])
    end
    should 'return true for an empty column' do
      @erratum.column = nil
      @erratum.set_matching_expression :x => '/foo/'
      assert @erratum.expression_matches?([''])
    end
    should 'return true for a matched regex' do
      @erratum.set_matching_expression :x => '/foo/'
      assert @erratum.expression_matches?(['foobar'])
    end
    should 'return false for an unmatched regex' do
      @erratum.set_matching_expression :x => '/foo/'
      assert !@erratum.expression_matches?(['you are no match'])
    end
    should 'return true for a matched string' do
      @erratum.set_matching_expression :x => 'foo'
      assert @erratum.expression_matches?(['foobar'])
    end
    should 'return false for an unmatched string' do
      @erratum.set_matching_expression :x => 'foo'
      assert !@erratum.expression_matches?(['you are no match'])
    end
    should 'allow ASCII regexes matched against UTF-8 text' do
      @erratum.set_matching_expression :x => ascii_8bit_regex
      assert !@erratum.expression_matches?([utf8_text])
    end
    should 'allow ASCII strings matched against UTF-8 text' do
      @erratum.set_matching_expression :x => 'foo'.force_encoding('ASCII-8BIT')
      assert @erratum.expression_matches?(['foobar'.force_encoding('UTF-8')])
    end
  end

  context 'set_matching_expression' do
    setup do
      errata = nil
      @erratum = Errata::Erratum.new errata, :section => 0
    end

    should 'return nil if expression is blank' do
      @erratum.set_matching_expression :x => ''
      assert_nil @erratum.instance_variable_get :@matching_expression
    end
    should 'return a case-insensitive regex' do
      regex = @erratum.set_matching_expression :x => '/foo/i'
      assert regex.casefold?
    end
    should 'return a case-sensitive regex' do
      regex = @erratum.set_matching_expression :x => '/foo/'
      assert !regex.casefold?
    end
    should 'convert an ASCII-8BIT regex to UTF-8' do
      regex = @erratum.set_matching_expression :x => ascii_8bit_regex
      assert_equal Encoding::UTF_8, regex.encoding
    end
    should 'do something crazy, but I cannot tell what'
    should 'look for prefixed whitespace' do
      regex = @erratum.set_matching_expression :x => 'spacey', :prefix => true
      assert_equal /\A\s*spacey/i, regex
    end
    should 'reutrn a string' do
      string = @erratum.set_matching_expression :x => 'Moose bite'
      assert_equal 'Moose bite', string
    end
  end
end
