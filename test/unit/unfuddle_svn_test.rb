require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/unfuddle_svn'

class UnfuddleSvnTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::UnfuddleSvn)
  end

  def test_init
    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '201')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)
    
    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    @scm.init
  end

  def test_init_should_raise_RuntimeError_if_unfuddle_api_call_fails
    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '500')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)
    
    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    assert_raise RuntimeError do
      @scm.init
    end
  end
  
  def test_init_should_raise_RuntimeError_if_any_step_raises_any_exception
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).raises(Net::HTTPNotFound)
  
    assert_raise RuntimeError do
      @scm.init
    end
  end
end
