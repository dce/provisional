require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/rails_application'

class RailsApplicationTest < Test::Unit::TestCase
  def test_initialize
    Dir.expects(:chdir).with('path')
    Rails::Generator::Base.expects(:use_application_sources!)
    generator_stub = stub()
    generator_stub.expects(:run).with(%w(. -m template_path), :generator => 'app')
    Rails::Generator::Scripts::Generate.expects(:new).returns(generator_stub)
    Provisional::RailsApplication.new('path', 'template_path')
  end
end
