require 'provisional/scm/git'
require 'net/http'
require 'builder'

module Provisional
  module SCM
    class Unfuddle < Provisional::SCM::Git
      def initialize(options)
        %w(username password domain id).each do |opt|
          raise ArgumentError, "#{opt} must be specified" unless options[opt]
        end
        super
      end

      def checkin
        begin
          repo = super

          xml = Builder::XmlMarkup.new
          xml.repository do
            xml.abbreviation @options['name']
            xml.title @options['name']
            xml.system 'git'
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
            raise RuntimeError, "Repository created locally, but not created on Unfuddle due to HTTP error: #{response.code}"
          end

          repo.add_remote('origin', "git@#{@options['domain']}.unfuddle.com:#{@options['domain']}/#{@options['name']}.git")
        rescue
          raise RuntimeError, "Repository created locally, but not pushed to Unfuddle due to exception: #{$!}"
        end
      end
    end
  end
end
