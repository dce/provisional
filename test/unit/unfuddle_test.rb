require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/unfuddle'

class UnfuddleTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Unfuddle)
  end

  def test_checkin
    stub_git_checkin do |stub|
      stub.expects(:add_remote)
    end
    @scm.expects(:create_repository)
    @scm.checkin
  end
end
