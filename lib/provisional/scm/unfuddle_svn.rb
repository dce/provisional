require 'provisional/scm/svn'
require 'net/http'
require 'builder'

module Provisional
  module SCM
    class UnfuddleSvn < Provisional::SCM::Svn
      def initialize(options)
        %w(username password domain id).each do |opt|
          raise ArgumentError, "#{opt} must be specified" unless options[opt]
        end
        super
      end

      def init
        begin
          xml = Builder::XmlMarkup.new
          xml.repository do
            xml.abbreviation @options['name']
            xml.title @options['name']
            xml.system 'svn'
            xml.projects do
              xml.project(:id => @options['id'])
            end
          end

          http = Net::HTTP.new("#{@options['domain']}.unfuddle.com", 80)
          request = Net::HTTP::Post.new('/api/v1/repositories.xml', 'Content-Type' => 'application/xml')
          request.basic_auth(@options['username'], @options['password'])
          request.body = xml.target!
          response, data = http.request(request)
          unless response.code == "201"
            raise RuntimeError, "Repository not created on Unfuddle due to HTTP error: #{response.code}"
          end

          @options['url'] = "http://#{@options['domain']}.unfuddle.com/svn/#{@options['domain']}_#{@options['name']}/"
        rescue
          raise RuntimeError, "Repository not created on Unfuddle due to exception: #{$!}"
        end
      end
    end
  end
end
