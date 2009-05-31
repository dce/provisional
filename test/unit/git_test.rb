require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class GitTest < Test::Unit::TestCase

  def setup
    @scm = new_scm(Provisional::SCM::Git)
  end

  def test_init
    FileUtils.expects(:mkdir_p).with('name')
    Dir.expects(:chdir).with('name')
    Git.expects(:init)
    @scm.init
  end

  def test_init_should_raise_RuntimeError_if_any_step_raises_any_exception
    FileUtils.expects(:mkdir_p).with('name').raises(Errno::EEXIST)
    assert_raise RuntimeError do
      @scm.init
    end
  end

  def test_generate_rails
    Provisional::RailsApplication.expects(:new)
    @scm.generate_rails
  end

  def test_generate_rails_should_raise_RuntimeError_if_any_step_raises_any_exception
    Provisional::RailsApplication.expects(:new).raises(RuntimeError)
    assert_raise RuntimeError do
      @scm.generate_rails
    end
  end

  def test_checkin
    stub_git_checkin
    @scm.checkin
  end

  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    Git.expects(:open).raises(ArgumentError)
    assert_raise RuntimeError do
      @scm.checkin
    end
  end
  
  def test_provision_should_call_init_generate_rails_and_checkin
    @scm.expects(:init)
    @scm.expects(:generate_rails)
    @scm.expects(:checkin)
    @scm.provision
  end
end
