require 'provisional/scm/git'

module Provisional
  module SCM
    class VigetGit < Provisional::SCM::Git
      def init
        steps = [
          "ssh -t sapporo.lab.viget.com sudo /usr/local/bin/git-o-mat.sh #{@options[:name]}",
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
