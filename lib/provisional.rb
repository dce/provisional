$:.unshift File.dirname(__FILE__)

require 'provisional/project'

def rescuing_exceptions(&block)
  begin
    yield
  rescue
    raise RuntimeError, "Repository not created due to exception: #{$!}"
  end
end
