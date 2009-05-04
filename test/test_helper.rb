# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'mocha'
require File.dirname(__FILE__) + '/../lib/provisional'

class Test::Unit::TestCase
  def new_scm(klass, options = {})
    klass.new({ 'name' => 'name', 'template_path' => 'template_path', 'domain' => 'domain', 'id' => 1,
                'username' => 'username', 'password' => 'password' }.merge(options))
  end
end
