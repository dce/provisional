require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class GitTest < Test::Unit::TestCase

  def setup
    @scm = Provisional::SCM::Git.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
  end

  context 'A Git SCM object' do
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
      Rails::Generator::Base.expects(:use_application_sources!)
      generator_stub = stub()
      generator_stub.expects(:run).with(%w(. -m template_path), :generator => 'app')
      Rails::Generator::Scripts::Generate.expects(:new).returns(generator_stub)
      @scm.generate_rails
    end

    should 'have a checkin method' do
      repo_stub = stub()
      repo_stub.expects(:add).with('.')
      repo_stub.expects(:commit).with('Initial commit by Provisional')
      Git.expects(:open).returns(repo_stub)
      Dir.expects(:chdir)
      File.expects(:open).with('.gitignore', 'w')
      @scm.checkin
    end
  end
end
