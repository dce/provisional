require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/svn'

class SvnTest < Test::Unit::TestCase

  def setup
    @scm = Provisional::SCM::Svn.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
  end

  context 'A Svn SCM object' do
    should 'have an init command' do
      cwd = Dir.getwd
      steps = [
        "svnadmin create name.repo",
        "svn checkout file:///#{cwd}/name.repo #{cwd}/name",
        "cd #{cwd}/name",
        "mkdir branches tags trunk",
        "svn add *",
        "svn commit -m 'Structure by Provisional'"
      ]
      assert_equal steps.join(' && '), @scm.init
    end

    should 'have a generate_rails command' do
      steps = [
        "cd name/trunk",
        "rails . -m template_path"
      ]
      assert_equal steps.join(' && '), @scm.generate_rails
    end

    should 'have a checkin command' do
      steps = [
        "cd name/trunk",
        "svn add *",
        "svn commit -m 'Initial commit by Provisional'"
      ]
      assert_equal steps.join(' && '), @scm.checkin
    end
  end
end
