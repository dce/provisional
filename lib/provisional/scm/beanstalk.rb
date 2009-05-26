require 'rubygems'
require 'active_resource'
require 'provisional/scm/svn'

module Beanstalk
  class Repository < ActiveResource::Base
  end
end

module Provisional
  module SCM
    class Beanstalk < Provisional::SCM::Svn
      def initialize(options)
        %w(username password domain).each do |opt|
          raise ArgumentError, "#{opt} must be specified" unless options[opt]
        end
        super
      end

      def init
        begin
          ::Beanstalk::Repository.site     = "http://#{@options['domain']}.beanstalkapp.com/"
          ::Beanstalk::Repository.user     = @options['username']
          ::Beanstalk::Repository.password = @options['password']
          ::Beanstalk::Repository.create   :name => @options['name'], :title => @options['name'], :create_structure => true
          @options['url'] = "http://#{@options['domain']}.svn.beanstalkapp.com/#{@options['name']}/"
        rescue
          raise RuntimeError, "Repository not created on Beanstalk due to exception: #{$!}"
        end
      end

      def generate_rails
        super(false)
      end
    end
  end
end
