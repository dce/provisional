require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/unfuddle_svn'

class UnfuddleSvnTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::UnfuddleSvn)
  end

  def test_init
    @scm.expects(:create_repository)
    @scm.init
  end
end
