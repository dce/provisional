# http://sneaq.net/textmate-wtf
$:.reject! { |e| e.include? 'TextMate' }

require 'rubygems'
require 'test/unit'
require 'mocha'
require File.dirname(__FILE__) + '/../lib/provisional'

class Test::Unit::TestCase
  def new_scm(klass, options = {})
    klass.new({ 'name' => 'name', 'template_path' => 'template_path', 'domain' => 'domain', 'id' => 1,
                'username' => 'username', 'password' => 'password' }.merge(options))
  end
  
  def stub_git_checkin(&block)
    repo_stub = stub()
    repo_stub.expects(:add).with('.')
    repo_stub.expects(:commit).with('Initial commit by Provisional')
    if block
      yield repo_stub
    end
    Git.expects(:open).returns(repo_stub)
    Dir.expects(:chdir)
    gitignore_file = stub()
    gitignore_file.expects(:puts).with(@scm.gitignore)
    File.expects(:open).with('.gitignore', 'w').yields(gitignore_file)
  end
end
