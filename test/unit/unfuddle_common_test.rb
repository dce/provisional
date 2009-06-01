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

  def test_checkin
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain',
               'name' => 'name', 'scm' => 'unfuddle', 'id' => 'id'}
    Unfuddle::Repository.expects(:create).with(:abbreviation => 'name',
                                  :title => 'name',
                                  :system => 'git',
                                  :projects => [{:id => 'id'}])
    create_repository(options)
  end

  def test_checkin_should_raise_RuntimeError_if_unfuddle_api_call_fails
    options = {'username' => 'username', 'password' => 'password', 'domain' => 'domain',
               'name' => 'name', 'scm' => 'unfuddle', 'id' => 'id'}
    Unfuddle::Repository.expects(:create).with(:abbreviation => 'name',
                                  :title => 'name',
                                  :system => 'git',
                                  :projects => [{:id => 'id'}]).raises(RuntimeError)

    assert_raise RuntimeError do
      create_repository(options)
    end
  end
end