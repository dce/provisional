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

  context 'A Github SCM object' do
    should 'know how to generate a gitignore file' do
      assert_equal Provisional::IGNORE_FILES.inject(''){|gitignore, duple| gitignore << "/#{duple[0]}/#{duple[1]}\n"}, @scm.gitignore
    end

    should 'have an init method' do
      FileUtils.expects(:mkdir_p).with('name')
      Dir.expects(:chdir).with('name')
      Git.expects(:init)
      @scm.init
    end

    should 'have a generate_rails method' do
      Dir.expects(:chdir)
      @scm.expects(:system).with("rails . -m template_path")
      @scm.generate_rails
    end

    should 'have a checkin method' do
      repo_stub = stub()
      repo_stub.expects(:add).with('.')
      repo_stub.expects(:commit).with('Initial commit by Provisional')
      repo_stub.expects(:config).with('github.user').returns('user')
      repo_stub.expects(:config).with('github.token').returns('token')
      repo_stub.expects(:add_remote)
      repo_stub.expects(:push)
      
      Git.expects(:open).returns(repo_stub)
      Dir.expects(:chdir)
      File.expects(:open).with('.gitignore', 'w')

      @scm.checkin
    end
  end
end
