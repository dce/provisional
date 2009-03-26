require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/github'

class GithubTest < Test::Unit::TestCase

  # TODO: mock/stub this
  GITHUB_LOGIN = `git config --get github.user`.chomp

  def setup
    @scm = Provisional::SCM::Github.new(
    {
      :name => 'name',
      :template_path => 'template_path',
      :rails => 'rails'
    }
    )
  end

  context 'A Github SCM object' do
    should 'have a different init command from the Git class' do
      # YAML.expects(:load_file).with('yaml').returns({'login' => 'login', 'password' => 'password'})
      steps = [
        "provisional-github-helper name",
        "mkdir -p name",
        "cd name",
        "git init",
        "touch .gitignore",
        "git add .gitignore",
        "git commit -m 'Structure by Provisional'",
        "git remote add origin git@github.com:#{GITHUB_LOGIN}/name.git",
        "git push origin master"
      ]
      assert_equal steps.join(' && '), @scm.init
    end

    should 'have the same generate_rails command as the Git class' do
      steps = [
        "cd name",
        "rails . -m template_path"
      ]
      assert_equal steps.join(' && '), @scm.generate_rails
    end

    should 'append a git push to the generate_rails command from the Git class' do
      steps = [
        "cd name",
        "printf \"#{Provisional::IGNORE_FILES.collect{|f| f[0]+'/'+f[1]+'\n'}}\" >.gitignore",
        "git add .",
        "git commit -m 'Initial commit by Provisional'",
        "git push"
      ]
      assert_equal steps.join(' && '), @scm.checkin
    end
  end
end
