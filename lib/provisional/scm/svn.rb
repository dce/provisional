require 'fileutils'
require 'provisional/rails_application'

module Provisional
  module SCM
    class Svn
      def initialize(options)
        @options = options
      end

      def init
        raise NotImplementedError, "The SVN scm cannot currently be used directly"
      end

      def generate_rails(create_structure = true)
        rescuing_exceptions do
          system("svn co --username=#{@options['username']} --password=#{@options['password']} #{@options['url']} #{@options['name']}")
          Dir.chdir @options['name']
          if create_structure
            %w(branches tags trunk).each {|d| Dir.mkdir(d)}
            system("svn add branches tags trunk")
            system("svn commit -m 'Structure by Provisional'")
          end
          Provisional::RailsApplication.new('trunk', @options['template_path'])
        end
      end

      def checkin
        # TODO: set svn:ignores
        rescuing_exceptions do
          system("svn add *")
          system("svn commit -m 'Initial commit by Provisional'")
        end
      end
    end
  end
end
