require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/unfuddle'

class UnfuddleTest < Test::Unit::TestCase
  def setup
    @scm = new_scm(Provisional::SCM::Unfuddle)
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

    @scm.expects(:create_repository)

    @scm.checkin
  end
end
