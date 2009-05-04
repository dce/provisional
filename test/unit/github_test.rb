require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/github'

class GithubTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Github)
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

    URI.expects(:parse).with('https://github.com/api/v2/yaml/repos/create')
    Net::HTTP.expects(:post_form).with(nil, { 'login' => 'user', 'token' => 'token', 'name' => 'name' })

    @scm.checkin
  end
  
  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')
    repo_stub.expects(:config).with('github.user').returns('user')
    repo_stub.expects(:config).with('github.token').returns('token')

    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)

    URI.expects(:parse).with('https://github.com/api/v2/yaml/repos/create')
    Net::HTTP.expects(:post_form).with(nil, { 'login' => 'user', 'token' => 'token', 'name' => 'name' }).raises(Net::HTTPUnauthorized)

    assert_raise RuntimeError do
      @scm.checkin
    end
  end
end
