require 'provisional/scm/svn'
require 'provisional/unfuddle_common'

module Provisional
  module SCM
    class UnfuddleSvn < Provisional::SCM::Svn
      def initialize(options)
        ensure_required_options(options)
        super
      end

      def init
        create_repository(@options)
        @options['url'] = "http://#{@options['domain']}.unfuddle.com/svn/#{@options['domain']}_#{@options['name']}/"
      end
    end
  end
end
