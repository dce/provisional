require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/beanstalk'

class BeanstalkTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Beanstalk, { 'url' => 'url' })
  end

  def test_init
    Beanstalk::Repository.expects(:create)
    @scm.init
  end

  def test_init_should_raise_RuntimeError_if_any_step_raises_any_exception
    Beanstalk::Repository.expects(:create).raises(Errno::ECONNREFUSED)
    assert_raise RuntimeError do
      @scm.init
    end
  end
  
  def test_generate_rails
    @scm.expects(:system).with("svn co --username=username --password=password url name")
    Dir.expects(:chdir).with('name')
    Provisional::RailsApplication.expects(:new)
    @scm.generate_rails
  end
end
