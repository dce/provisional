require 'fileutils'
require 'git'

module Provisional
  module SCM
    class Git
      def initialize(options)
        @options = options
      end

      def gitignore
        Provisional::IGNORE_FILES.inject(''){|gitignore, duple| gitignore << "/#{duple[0]}/#{duple[1]}\n"}
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
        Dir.chdir @options[:path]
        File.open('.gitignore', 'w') do |f|
          f.puts gitignore
        end
        repo.add '.'
        repo.commit 'Initial commit by Provisional'
      end
    end
  end
end
