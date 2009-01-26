require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class GitTest < Test::Unit::TestCase

  def setup
    @scm = Provisional::SCM::Git.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
  end

  context 'A Git SCM object' do
    should 'have an init command' do
      steps = [
        "mkdir -p name",
        "cd name",
        "git init"
      ]
      assert_equal steps.join(' && '), @scm.init
    end

    should 'have a generate_rails command' do
      steps = [
        "cd name",
        "rails . -m template_path"
      ]
      assert_equal steps.join(' && '), @scm.generate_rails
    end

    should 'have a checkin command' do
      steps = [
        "cd name",
        "printf \"#{Provisional::IGNORE_FILES.collect{|f| f[0]+'/'+f[1]+'\n'}}\" >.gitignore",
        "git add .",
        "git commit -m 'Initial commit by Provisional'"
      ]
      assert_equal steps.join(' && '), @scm.checkin
    end
  end
end
