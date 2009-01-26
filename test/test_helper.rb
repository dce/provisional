# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'mocha'
require 'shoulda'
require File.dirname(__FILE__) + '/../lib/provisional'