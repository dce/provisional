module Provisional
  module SCM
    class Git
      def initialize(options)
        @options = options
      end

      def init
        steps = [
          "mkdir -p #{@options[:name]}",
          "cd #{@options[:name]}",
          "git init"
        ]
        steps.join(' && ')
      end

      def generate_rails
        steps = [
          "cd #{@options[:name]}",
          "#{@options[:rails]} . -m #{@options[:template_path]}"
        ]
        steps.join(' && ')
      end

      def checkin
        steps = [
          "cd #{@options[:name]}",
          "git add .",
          "git commit -m 'Initial commit by Provisional'"
        ]
        steps.join(' && ')
      end
    end
  end
end
