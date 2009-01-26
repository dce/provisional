require 'provisional/scm/svn'

module Provisional
  module SCM
    class VigetSvn < Provisional::SCM::Svn
      def init
        cwd = Dir.getwd
        steps = [
          "ssh -t sapporo.lab.viget.com sudo /usr/local/bin/svn-o-mat.sh #{@opts[:name]}",
          "svn checkout svn://svn.lab.viget.com/#{@opts[:name]}"
        ]
        steps.join(' && ')
      end
    end
  end
end
