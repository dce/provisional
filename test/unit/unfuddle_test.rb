require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/unfuddle'

class UnfuddleTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Unfuddle)
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
    repo_stub.expects(:add_remote)

    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)

    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '201')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)
    
    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    @scm.checkin
  end

  def test_checkin_should_raise_RuntimeError_if_unfuddle_api_call_fails
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')

    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)

    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '500')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)
    
    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    assert_raise RuntimeError do
      @scm.checkin
    end
  end
  
  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')
  
    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)
  
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).raises(Net::HTTPNotFound)
  
    assert_raise RuntimeError do
      @scm.checkin
    end
  end
end
