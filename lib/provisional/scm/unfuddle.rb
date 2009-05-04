require 'provisional/scm/git'
require 'provisional/unfuddle_common'

module Provisional
  module SCM
    class Unfuddle < Provisional::SCM::Git
      def initialize(options)
        ensure_required_options(options)
        super
      end

      def checkin
        repo = super
        create_repository(@options)
        repo.add_remote('origin', "git@#{@options['domain']}.unfuddle.com:#{@options['domain']}/#{@options['name']}.git")
      end
    end
  end
end
