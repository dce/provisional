require 'provisional/scm/svn'

module Provisional
  module SCM
    class VigetSvn < Provisional::SCM::Svn
      def init
        steps = [
          "ssh -t sapporo.lab.viget.com sudo /usr/local/bin/svn-o-mat.sh #{@options[:name]}",
          "svn checkout svn://svn.lab.viget.com/#{@options[:name]}"
        ]
        steps.join(' && ')
      end
    end
  end
end
