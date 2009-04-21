require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/github'

class GithubTest < Test::Unit::TestCase
  def setup
    @scm = Provisional::SCM::Github.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
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

  def test_generate_rails
    Dir.expects(:chdir)
    Rails::Generator::Base.expects(:use_application_sources!)
    generator_stub = stub()
    generator_stub.expects(:run).with(%w(. -m template_path), :generator => 'app')
    Rails::Generator::Scripts::Generate.expects(:new).returns(generator_stub)
    @scm.generate_rails
  end

  def test_checkin
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')
    repo_stub.expects(:config).with('github.user').returns('user')
    repo_stub.expects(:config).with('github.token').returns('token')
    repo_stub.expects(:add_remote)
    repo_stub.expects(:push)

    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)

    @scm.checkin
  end
end
