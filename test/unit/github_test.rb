require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/github'

class GithubTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Github)
  end

  def test_checkin
    stub_git_checkin do |stub|
      stub.expects(:config).with('github.user').returns('user')
      stub.expects(:config).with('github.token').returns('token')
      stub.expects(:add_remote)
      stub.expects(:push)
    end

    stub_github do |stub|
      stub.expects(:request).returns(true)
    end

    @scm.checkin
  end

  def test_checkin_should_fail_if_any_step_raises_any_exception
    stub_git_checkin do |stub|
      stub.expects(:config).with('github.user').returns('user')
      stub.expects(:config).with('github.token').returns('token')
    end

    stub_github do |stub|
      stub.expects(:request).raises(Net::HTTPUnauthorized)
    end

    assert_raise RuntimeError do
      @scm.checkin
    end
  end

  private

  def stub_github
    http = stub

    connection = stub(:use_ssl= => true, :verify_mode= => true)
    connection.expects(:start).yields(http)

    Net::HTTP.expects(:new).with('github.com', 443).returns(connection)

    yield http
  end
end
