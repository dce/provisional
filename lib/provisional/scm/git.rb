module Provisional
  module SCM
    class Git
      def initialize(opts)
        @opts = opts
      end

      def init
        steps = [
          "mkdir -p #{@opts[:name]}",
          "cd #{@opts[:name]}",
          "git init"
        ]
        steps.join(' && ')
      end

      def generate_rails
        steps = [
          "cd #{@opts[:name]}",
          "#{@opts[:rails]} . -m #{@opts[:template_path]}"
        ]
        steps.join(' && ')
      end

      def checkin
        steps = [
          "cd #{@opts[:name]}",
          "git add .",
          "git commit -m 'Initial commit by Provisional'"
        ]
        steps.join(' && ')
      end
    end
  end
end
