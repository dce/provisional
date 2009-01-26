# FIXME: needs to handle ignored files

module Provisional
  module SCM
    class Svn
      def initialize(options)
        @options = options
      end

      def init
        cwd = Dir.getwd
        steps = [
          "svnadmin create #{@options[:name]}.repo",
          "svn checkout file:///#{cwd}/#{@options[:name]}.repo #{cwd}/#{@options[:name]}",
          "cd #{cwd}/#{@options[:name]}",
          "mkdir branches tags trunk",
          "svn add *",
          "svn commit -m 'Structure by Provisional'"
        ]
        steps.join(' && ')
      end

      def generate_rails
        steps = [
          "cd #{@options[:name]}/trunk",
          "#{@options[:rails]} . -m #{@options[:template_path]}"
        ]
        steps.join(' && ')
      end

      def checkin
        steps = [
          "cd #{@options[:name]}/trunk",
          "svn add *",
          "svn commit -m 'Initial commit by Provisional'"
        ]
        steps.join(' && ')
      end
    end
  end
end
