require 'fileutils'
require 'git'
require 'provisional/rails_application'

module Provisional
  module SCM
    class Git
      def initialize(options)
        @options = options
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
          repo.add '.'
          repo.commit 'Initial commit by Provisional'
          repo
        end
      end
      
      def provision
        self.init
        self.generate_rails
        self.checkin
      end
    end
  end
end
