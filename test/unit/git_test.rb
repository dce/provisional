require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class GitTest < Test::Unit::TestCase

  def setup
    @scm = new_scm(Provisional::SCM::Git)
  end

  def test_gitignore
    assert_equal Provisional::IGNORE_FILES.join("\n"), @scm.gitignore
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
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')
    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)
    @scm.checkin
  end

  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    Git.expects(:open).raises(ArgumentError)
    assert_raise RuntimeError do
      @scm.checkin
    end
  end
end
