require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/viget_svn'

class VigetSvnTest < Test::Unit::TestCase

  def setup
    @scm = Provisional::SCM::VigetSvn.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
  end

  context 'A VigetSvn SCM object' do
    should 'have a different init command from the Svn class' do
      cwd = Dir.getwd
      steps = [
        "ssh -t sapporo.lab.viget.com sudo /usr/local/bin/svn-o-mat.sh name",
        "svn checkout svn://svn.lab.viget.com/name"
      ]
      assert_equal steps.join(' && '), @scm.init
    end

    should 'have the same generate_rails command as the Svn class' do
      steps = [
        "cd name/trunk",
        "rails . -m template_path"
      ]
      assert_equal steps.join(' && '), @scm.generate_rails
    end

    should 'have the same checkin command as the Svn class' do
      steps = [
        "cd name/trunk",
        "svn add *",
        Provisional::IGNORE_FILES.collect{|f| "svn propset svn:ignore '#{f[1]}' #{f[0]}"},          
        "svn commit -m 'Initial commit by Provisional'"
      ]
      assert_equal steps.join(' && '), @scm.checkin
    end
  end
end
