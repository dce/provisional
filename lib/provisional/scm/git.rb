require 'fileutils'
require 'git'
require 'rails/version'
require 'rails_generator'
require 'rails_generator/scripts/generate'

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
        FileUtils.mkdir_p @options[:name]
        Dir.chdir @options[:name]
        @options[:path] = Dir.getwd
        ::Git.init
      end

      def generate_rails
        generator_options = ['.', '-m', @options[:template_path]]
        Dir.chdir @options[:path]
        Rails::Generator::Base.use_application_sources!
        Rails::Generator::Scripts::Generate.new.run generator_options, :generator => 'app'
      end

      def checkin
        repo = ::Git.open @options[:path]
        Dir.chdir @options[:path]
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
