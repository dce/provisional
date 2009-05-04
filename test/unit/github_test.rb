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

    URI.expects(:parse).with('https://github.com/api/v2/yaml/repos/create')
    Net::HTTP.expects(:post_form).with(nil, { 'login' => 'user', 'token' => 'token', 'name' => 'name' })

    @scm.checkin
  end

  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    stub_git_checkin do |stub|
      stub.expects(:config).with('github.user').returns('user')
      stub.expects(:config).with('github.token').returns('token')
    end

    URI.expects(:parse).with('https://github.com/api/v2/yaml/repos/create')
    Net::HTTP.expects(:post_form).with(nil, { 'login' => 'user', 'token' => 'token', 'name' => 'name' }).raises(Net::HTTPUnauthorized)

    assert_raise RuntimeError do
      @scm.checkin
    end
  end
end
