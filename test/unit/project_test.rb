require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class ProjectTest < Test::Unit::TestCase

  RAILS = `which rails`.chomp
  DEFAULT_TEMPLATE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../../lib/provisional/templates/viget.rb'))

  def stub_git
    git_stub = stub()
    git_stub.expects(:init).returns('true')
    git_stub.expects(:generate_rails).returns('true')
    git_stub.expects(:checkin).returns('true')
    Provisional::SCM::Git.expects(:new).returns(git_stub)
  end

  def new_project(opts = {})
    opts = {:name => 'name', :template => 'viget', :rails => RAILS, :scm => 'git'}.merge(opts)
    Provisional::Project.new(opts)
  end

  context 'A Project object' do
    should 'call init, generate_rails and checkin' do
      stub_git
      new_project
    end

    should 'be able to use a literal template path' do
      stub_git
      path_to_my_template = File.expand_path('my_template.rb')
      File.expects(:exist?).with(path_to_my_template).times(2).returns(true)
      File.expects(:exist?).with('name').returns(false)
      File.expects(:exist?).with(RAILS).returns(true)
      project = new_project(:template => 'my_template.rb')
      assert_equal path_to_my_template, project.options[:template_path]
    end

    should 'find the template_path based on the template option' do
      stub_git
      assert_equal DEFAULT_TEMPLATE_PATH, new_project.options[:template_path]
    end

    should 'raise ArgumentError if name is not specified' do
      assert_raise ArgumentError do
        new_project(:name => nil)
      end
    end

    should 'raise ArgumentError if name already exists' do
      File.expects(:exist?).with('name').returns(true)
      File.expects(:exist?).with(File.expand_path('viget')).returns(false)
      File.expects(:exist?).with(DEFAULT_TEMPLATE_PATH).returns(true)
      assert_raise ArgumentError do
        new_project
      end
    end

    should 'raise ArgumentError if name.repo already exists and scm is svn' do
      File.expects(:exist?).with('name').returns(false)
      File.expects(:exist?).with('name.repo').returns(true)
      File.expects(:exist?).with(DEFAULT_TEMPLATE_PATH).returns(true)
      File.expects(:exist?).with(File.expand_path('viget')).returns(false)
      assert_raise ArgumentError do
        new_project(:scm => 'svn')
      end
    end

    should 'raise ArgumentError if unsupported scm is specified' do
      assert_raise ArgumentError do
        new_project(:scm => 'bogus')
      end
    end

    should 'raise ArgumentError if no scm is specified' do
      assert_raise ArgumentError do
        new_project(:scm => nil)
      end
    end

    should 'raise ArgumentError if no rails is specified' do
      assert_raise ArgumentError do
        new_project(:rails => nil)
      end
    end

    should 'raise ArgumentError if invalid rails is specified' do
      assert_raise ArgumentError do
        new_project(:rails => 'bogus')
      end
    end

    should 'raise ArgumentError if invalid template is specified' do
      assert_raise ArgumentError do
        new_project(:template => 'bogus')
      end
    end

    should 'not raise ArgumentError if a valid http template url is specified' do
      stub_git
      assert_nothing_raised do
        new_project(:template => 'http://example.com/')
      end
    end

    should 'not raise ArgumentError if a valid https template url is specified' do
      stub_git
      assert_nothing_raised do
        new_project(:template => 'https://example.com/')
      end
    end

    should 'raise ArgumentError if a valid other template url is specified' do
      assert_raise ArgumentError do
        new_project(:template => 'ftp://example.com/')
      end
    end

    should 'raise ArgumentError if an invalid url is specified' do
      assert_raise ArgumentError do
        new_project(:template => 'bogus://awesome.pants/')
      end
    end
  end
end
