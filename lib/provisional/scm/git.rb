require 'fileutils'
require 'git'
require 'provisional/rails_application'

module Provisional
  module SCM
    class Git
      def initialize(options)
        @options = options
      end

      def gitignore
        Provisional::IGNORE_FILES.join("\n")
      end

      def init
        rescuing_exceptions do
          FileUtils.mkdir_p @options['name']
          Dir.chdir @options['name']
          @options['path'] = Dir.getwd
          ::Git.init
        end
      end

      def generate_rails
        rescuing_exceptions do
          Provisional::RailsApplication.new(@options['path'], @options['template_path'])
        end
      end

      def checkin
        rescuing_exceptions do
          repo = ::Git.open @options['path']
          Dir.chdir @options['path']
          File.open('.gitignore', 'w') do |f|
            f.puts gitignore
          end
          repo.add '.'
          repo.commit 'Initial commit by Provisional'
          repo
        end
      end
    end
  end
end
