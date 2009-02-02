require 'provisional/scm/git'
require 'yaml'

module Provisional
  module SCM
    class Github < Provisional::SCM::Git
      def init
        begin
          github_config = YAML.load_file(@options[:github])
        rescue
          raise ArgumentError, "could not be loaded: #{@options[:github]}"
        end

        steps = [
          "provisional-github-helper #{@options[:name]} #{@options[:github]}",
          "mkdir -p #{@options[:name]}",
          "cd #{@options[:name]}",
          "git init",
          "touch .gitignore",
          "git add .gitignore",
          "git commit -m 'Structure by Provisional'",
          "git remote add origin git@github.com:#{github_config['login']}/#{@options[:name]}.git",
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
