require 'provisional/scm/git'
require 'net/http'

module Provisional
  module SCM
    class Github < Provisional::SCM::Git
      def checkin
        repo = super
        github_user = repo.config 'github.user'
        github_token = repo.config 'github.token'
        Net::HTTP.post_form URI.parse('http://github.com/api/v2/yaml/repos/create'), {
          'login' => github_user,
          'token' => github_token,
          'name' => @options[:name]
        }
        repo.add_remote('origin', "git@github.com:#{github_user}/#{@options[:name]}.git")
        repo.push
      end
    end
  end
end
