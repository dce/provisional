require 'fileutils'
require 'git'

module Provisional
  module SCM
    class Git
      def initialize(options)
        @options = options
      end

      def init
        FileUtils.mkdir_p @options[:name]
        Dir.chdir @options[:name]
        @options[:path] = Dir.getwd
        ::Git.init
      end

      def generate_rails
        Dir.chdir @options[:path]
        system "#{@options[:rails]} . -m #{@options[:template_path]}"
      end

      def checkin
        repo = ::Git.open @options[:path]
        # TODO: gitignore
        repo.add '.'
        repo.commit 'Initial commit by Provisional'
      end
    end
  end
end
