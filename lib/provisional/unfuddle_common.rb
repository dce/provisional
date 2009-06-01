require 'rubygems'
require 'active_resource'

module Unfuddle
  class Repository < ActiveResource::Base
  end
end

def ensure_required_options(options)
  %w(username password domain id).each do |opt|
    raise ArgumentError, "#{opt} must be specified" unless options[opt]
  end
end

def create_repository(options)
  begin
    Unfuddle::Repository.site     = "http://#{options['domain']}.unfuddle.com/api/v1"
    Unfuddle::Repository.user     = options['username']
    Unfuddle::Repository.password = options['password']
    Unfuddle::Repository.create   :abbreviation => options['name'],
                                  :title => options['name'],
                                  :system => options['scm'] == 'unfuddle_svn' ? 'svn' : 'git',
                                  :projects => [{:id => options['id']}]
  rescue
    raise RuntimeError, "Repository not created on Unfuddle due to exception: #{$!}"
  end
end
