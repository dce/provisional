require 'provisional/scm/git'
require 'yaml'

module Provisional
  module SCM
    class Github < Provisional::SCM::Git
      def init

        # TODO: figure out a better way of getting this
        github_login = `git config --get github.user`.chomp

        steps = [
          "provisional-github-helper #{@options[:name]}",
          "mkdir -p #{@options[:name]}",
          "cd #{@options[:name]}",
          "git init",
          "touch .gitignore",
          "git add .gitignore",
          "git commit -m 'Structure by Provisional'",
          "git remote add origin git@github.com:#{github_login}/#{@options[:name]}.git",
          "git push origin master"
        ]
        steps.join(' && ')
      end

      def checkin
        super + ' && git push'
      end
    end
  end
end
