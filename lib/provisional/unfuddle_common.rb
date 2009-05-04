require 'net/http'
require 'builder'

def ensure_required_options(options)
  %w(username password domain id).each do |opt|
    raise ArgumentError, "#{opt} must be specified" unless options[opt]
  end
end

def xml_payload(options)
  xml = Builder::XmlMarkup.new
  xml.repository do
    xml.abbreviation options['name']
    xml.title options['name']
    xml.system options['scm']
    xml.projects do
      xml.project(:id => options['id'])
    end
  end
  return xml.target!
end

def create_repository(options)
  begin
    http = Net::HTTP.new("#{options['domain']}.unfuddle.com", 80)
    request = Net::HTTP::Post.new('/api/v1/repositories.xml', 'Content-Type' => 'application/xml')
    request.basic_auth(options['username'], options['password'])
    request.body = xml_payload(options)
    response, data = http.request(request)
    unless response.code == "201"
      raise RuntimeError, "Repository not created on Unfuddle due to HTTP error: #{response.code}"
    end
  rescue
    raise RuntimeError, "Repository not created on Unfuddle due to exception: #{$!}"
  end
end
