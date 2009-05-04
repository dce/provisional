require 'fileutils'
require 'rails/version'
require 'rails_generator'
require 'rails_generator/scripts/generate'

module Provisional
  module SCM
    class Svn
      def initialize(options)
        @options = options
      end

      def rescuing_exceptions(&block)
        begin
          yield
        rescue
          raise RuntimeError, "Repository not created due to exception: #{$!}"
        end
      end

      def init
        raise NotImplementedError, "The SVN scm cannot currently be used directly"
      end

      def generate_rails
        rescuing_exceptions do
          system("svn co --username=#{@options['username']} --password=#{@options['password']} #{@options['url']} #{@options['name']}")
          Dir.chdir @options['name']
          %w(branches tags trunk).each {|d| Dir.mkdir(d)}
          system("svn add branches tags trunk")
          system("svn commit -m 'Structure by Provisional'")
          Dir.chdir 'trunk'

          generator_options = ['.', '-m', @options['template_path']]
          Rails::Generator::Base.use_application_sources!
          Rails::Generator::Scripts::Generate.new.run generator_options, :generator => 'app'
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
