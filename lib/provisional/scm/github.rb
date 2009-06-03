require 'provisional/scm/git'
require 'net/http'

module Provisional
  module SCM
    class Github < Provisional::SCM::Git
      def checkin
        begin
          repo = super
          github_user = repo.config 'github.user'
          github_token = repo.config 'github.token'

          connection = Net::HTTP.new('github.com', 443)
          connection.use_ssl = true
          connection.verify_mode = OpenSSL::SSL::VERIFY_NONE

          connection.start do |http|
            req = Net::HTTP::Post.new("/api/v2/yaml/repos/create")
            req.set_form_data(
              'login' => github_user,
              'token' => github_token,
              'name'  => @options['name']
            )
            http.request(req)
          end

          repo.add_remote('origin', "git@github.com:#{github_user}/#{@options['name']}.git")
          repo.push
        rescue
          raise RuntimeError, "Repository created locally, but not pushed to GitHub due to exception: #{$!}"
        end
      end
    end
  end
end
