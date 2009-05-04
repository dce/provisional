require 'active_support'
require 'uri'
require 'yaml'

module Provisional
  class Project
    attr_reader :options
    
    def initialize(options)
      @options = HashWithIndifferentAccess.new
      if options[:config]
        begin
          @options = @options.merge(YAML.load_file(options[:config]))
        rescue
          raise ArgumentError, "could not be loaded or parsed: #{options[:config]}"
        end
      end
      @options = @options.merge(options.reject{|k,v| v.nil?})

      @options[:scm] ||= 'git'
      @options[:template] ||= 'viget'

      unless is_valid_url?(@options['template'])
        if File.exist?(File.expand_path(@options['template']))
          @options['template_path'] = File.expand_path(@options['template'])
        else
          @options['template_path'] = File.expand_path(File.join(File.dirname(__FILE__),'templates',"#{@options['template']}.rb"))
        end
        raise ArgumentError, "is not valid: #{@options['template']}" unless File.exist?(@options['template_path'])
      else
        @options['template_path'] = @options['template']
      end

      raise ArgumentError, "name must be specified" unless @options['name']
      raise ArgumentError, "already exists: #{@options['name']}" if File.exist?(@options['name'])
      raise ArgumentError, "already exists: #{@options['name']}.repo" if @options['scm'] == 'svn' && File.exist?("#{@options['name']}.repo")

      begin
        require "provisional/scm/#{@options['scm']}"
      rescue MissingSourceFile
        raise ArgumentError, "is not supported: #{@options['scm']}"
      end

      scm_class = "Provisional::SCM::#{@options['scm'].classify}".constantize
      scm = scm_class.new(@options)
      scm.init
      scm.generate_rails
      scm.checkin
    end

    def is_valid_url?(url)
      begin
        [URI::HTTP, URI::HTTPS].include?(URI.parse(url).class)
      rescue URI::InvalidURIError
        false
      end
    end

  end
end
