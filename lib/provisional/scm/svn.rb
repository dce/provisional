# FIXME: needs to handle ignored files

module Provisional
  module SCM
    class Svn
      def initialize(opts)
        @opts = opts
      end

      def init
        cwd = Dir.getwd
        steps = [
          "svnadmin create #{@opts[:name]}.repo",
          "svn checkout file:///#{cwd}/#{@opts[:name]}.repo #{cwd}/#{@opts[:name]}",
          "cd #{cwd}/#{@opts[:name]}",
          "mkdir branches tags trunk",
          "svn add *",
          "svn commit -m 'Structure by Provisional'"
        ]
        steps.join(' && ')
      end

      def generate_rails
        steps = [
          "cd #{@opts[:name]}/trunk",
          "#{@opts[:rails]} . -m #{@opts[:template_path]}"
        ]
        steps.join(' && ')
      end

      def checkin
        steps = [
          "cd #{@opts[:name]}/trunk",
          "svn add *",
          "svn commit -m 'Initial commit by Provisional'"
        ]
        steps.join(' && ')
      end
    end
  end
end
