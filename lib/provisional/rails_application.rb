require 'rails/version'
require 'rails_generator'
require 'rails_generator/scripts/generate'

module Provisional
  class RailsApplication
    def initialize(path, template_path)
      Dir.chdir(path)
      Rails::Generator::Base.use_application_sources!
      Rails::Generator::Scripts::Generate.new.run(['.', '-m', template_path], :generator => 'app')
    end
  end
end