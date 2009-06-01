require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/svn'

class SvnTest < Test::Unit::TestCase

  def setup
    @scm = new_scm(Provisional::SCM::Svn, { 'url' => 'url' })
  end

  def test_init
    assert_raise NotImplementedError do
      @scm.init
    end
  end

  def test_generate_rails
    @scm.expects(:system).with("svn co --username=username --password=password url name")
    Dir.expects(:chdir).with('name')
    %w(branches tags trunk).each {|d| Dir.expects(:mkdir).with(d)}
    @scm.expects(:system).with("svn add branches tags trunk")
    @scm.expects(:system).with("svn commit -m 'Structure by Provisional'")
    Provisional::RailsApplication.expects(:new)
    @scm.generate_rails
  end

  def test_generate_rails_can_optionally_skip_svn_structure_creation
    @scm.expects(:system).with("svn co --username=username --password=password url name")
    Dir.expects(:chdir).with('name')
    Provisional::RailsApplication.expects(:new)
    @scm.generate_rails(false)
  end

  def test_generate_rails_should_fail_if_any_step_raises_any_exception
    @scm.expects(:system).with("svn co --username=username --password=password url name")
    Dir.expects(:chdir).with('name').raises(Errno::ENOENT)
    assert_raise RuntimeError do
      @scm.generate_rails
    end
  end

  def test_checkin
    @scm.expects(:system).with("svn add *")
    @scm.expects(:system).with("svn commit -m 'Initial commit by Provisional'")
    @scm.checkin
  end

  def test_checkin_should_fail_if_any_step_raises_any_exception
    @scm.expects(:system).with("svn add *").raises(RuntimeError)
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
