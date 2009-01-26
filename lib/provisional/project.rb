require 'active_support'

module Provisional
  class Project
    attr_reader :options

    def initialize(options)
      @options = options
      @options[:template_path] = File.expand_path(File.join(File.dirname(__FILE__),'templates',"#{@options[:template]}.rb"))

      raise ArgumentError, "must be specified" unless @options[:name]
      raise ArgumentError, "already exists: #{@options[:name]}" if File.exist?(@options[:name])
      raise ArgumentError, "already exists: #{@options[:name]}.repo" if @options[:scm] == 'svn' && File.exist?("#{@options[:name]}.repo")

      begin
        require "provisional/scm/#{@options[:scm]}"
      rescue MissingSourceFile
        raise ArgumentError, "is not supported: #{@options[:scm]}"
      end

      raise ArgumentError, "must be specified" if @options[:rails].to_s.empty?
      raise ArgumentError, "is not valid: #{@options[:rails]}" unless File.exist?(@options[:rails]) && File.executable?(@options[:rails])

      raise ArgumentError, "is not valid: #{@options[:template]}" unless File.exist?(@options[:template_path])

      scm_class = "Provisional::SCM::#{@options[:scm].classify}".constantize
      scm = scm_class.new(@options)
      system scm.init
      system scm.generate_rails
      system scm.checkin
    end
  end
end
