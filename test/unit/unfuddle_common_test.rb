require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/unfuddle_common'

class UnfuddleCommonTest < Test::Unit::TestCase
  def test_ensure_required_options_should_pass_if_all_options_present
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain', 'id' => 1}
    assert ensure_required_options(options)
  end

  def test_ensure_required_options_should_raise_if_any_option_missing
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain'}
    assert_raise ArgumentError do
      ensure_required_options(options)
    end
  end

  def test_xml_payload
    options   = {'name' => 'name', 'scm' => 'git', 'id' => 1}
    expected  = '<repository><abbreviation>name</abbreviation><title>name</title><system>git</system>'
    expected += '<projects><project id="1"/></projects></repository>'
    assert_equal expected, xml_payload(options)
  end

  def test_checkin
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain'}
    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '201')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)

    self.expects(:xml_payload).returns("")

    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    create_repository(options)
  end

  def test_checkin_should_raise_RuntimeError_if_unfuddle_api_call_fails
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain'}
    request_stub = stub()
    request_stub.expects(:basic_auth).with('username', 'password')
    request_stub.expects(:body=)
    response_stub = stub(:code => '500')
    http_stub = stub()
    http_stub.expects(:request).with(request_stub).returns(response_stub, nil)

    self.expects(:xml_payload).returns("")

    Net::HTTP::Post.expects(:new).with('/api/v1/repositories.xml', 'Content-Type' => 'application/xml').returns(request_stub)
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).returns(http_stub)

    assert_raise RuntimeError do
      create_repository(options)
    end
  end

  def test_checkin_should_raise_RuntimeError_if_any_step_raises_any_exception
    options = {'domain' => 'domain'}
    Net::HTTP.expects(:new).with("domain.unfuddle.com", 80).raises(Net::HTTPNotFound)

    assert_raise RuntimeError do
      create_repository(options)
    end
  end
end