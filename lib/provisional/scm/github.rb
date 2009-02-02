require 'provisional/scm/git'

module Provisional
  module SCM
    class Github < Provisional::SCM::Git
      def init
        steps = [
          "provisional-github-helper #{@options[:name]} #{@options[:github]}",
          "mkdir -p #{@options[:name]}",
          "cd #{@options[:name]}",
          "git init",
          "touch .gitignore",
          "git add .gitignore",
          "git commit -m 'Structure by Provisional'",
          "git remote add origin git.lab.viget.com:/srv/git/#{@options[:name]}.git",
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
