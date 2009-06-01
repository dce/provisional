require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/provisional/scm/git'

class ProjectTest < Test::Unit::TestCase

  DEFAULT_TEMPLATE_PATH = File.expand_path(File.join(File.dirname(__FILE__), '../../lib/provisional/templates/viget.rb'))

  def stub_git
    git_stub = stub()
    git_stub.expects(:provision).returns('true')
    Provisional::SCM::Git.expects(:new).returns(git_stub)
  end

  def new_project(opts = {})
    opts = {:name => 'name', :template => 'viget', :scm => 'git'}.merge(opts)
    Provisional::Project.new(opts)
  end

  def test_should_be_able_to_use_a_config_file
    options = {'name' => 'albert', 'template' => 'viget', 'scm' => 'git'}
    YAML.expects(:load_file).with('config.yml').returns(options)
    stub_git
    project = Provisional::Project.new(:config => 'config.yml')
    assert_equal 'albert', project.options[:name]
  end

  def test_should_bail_on_config_file_errors
    YAML.expects(:load_file).with('config.yml').raises(Errno::ENOENT)
    assert_raise ArgumentError do
      Provisional::Project.new(:config => 'config.yml')
    end
  end

  def test_new_project_should_call_init_generate_rails_and_checkin
    stub_git
    new_project
  end

  def test_should_be_able_to_use_a_literal_template_path
    stub_git
    path_to_my_template = File.expand_path('my_template.rb')
    File.expects(:exist?).with(path_to_my_template).times(2).returns(true)
    File.expects(:exist?).with('name').returns(false)
    project = new_project(:template => 'my_template.rb')
    assert_equal path_to_my_template, project.options[:template_path]
  end

  def test_should_find_the_template_path_based_on_the_template_option
    stub_git
    assert_equal DEFAULT_TEMPLATE_PATH, new_project.options[:template_path]
  end

  def test_should_raise_argumenterror_if_invalid_template_url_is_specified
    bogus_url = 'bagel://pants/wizard'
    URI.expects(:parse).with(bogus_url).raises(URI::InvalidURIError)
    assert_raise ArgumentError do
      project = new_project(:template => bogus_url)
    end
  end

  def test_should_raise_argumenterror_if_name_is_not_specified
    assert_raise ArgumentError do
      new_project(:name => nil)
    end
  end

  def test_should_raise_argumenterror_if_name_already_exists
    File.expects(:exist?).with('name').returns(true)
    File.expects(:exist?).with(File.expand_path('viget')).returns(false)
    File.expects(:exist?).with(DEFAULT_TEMPLATE_PATH).returns(true)
    assert_raise ArgumentError do
      new_project
    end
  end

  def test_should_raise_argumenterror_if_namedotrepo_already_exists_and_scm_is_svn
    File.expects(:exist?).with('name').returns(false)
    File.expects(:exist?).with('name.repo').returns(true)
    File.expects(:exist?).with(DEFAULT_TEMPLATE_PATH).returns(true)
    File.expects(:exist?).with(File.expand_path('viget')).returns(false)
    assert_raise ArgumentError do
      new_project(:scm => 'svn')
    end
  end

  def test_should_raise_argumenterror_if_unsupported_scm_is_specified
    assert_raise ArgumentError do
      new_project(:scm => 'bogus')
    end
  end

  def test_should_raise_argumenterror_if_invalid_template_is_specified
    assert_raise ArgumentError do
      new_project(:template => 'bogus')
    end
  end

  def test_should_not_raise_argumenterror_if_a_valid_http_template_url_is_specified
    stub_git
    assert_nothing_raised do
      new_project(:template => 'http://example.com/')
    end
  end

  def test_should_not_raise_argumenterror_if_a_valid_https_template_url_is_specified
    stub_git
    assert_nothing_raised do
      new_project(:template => 'https://example.com/')
    end
  end

  def test_should_raise_argumenterror_if_a_valid_other_template_url_is_specified
    assert_raise ArgumentError do
      new_project(:template => 'ftp://example.com/')
    end
  end

  def test_should_raise_argumenterror_if_an_invalid_url_is_specified
    assert_raise ArgumentError do
      new_project(:template => 'bogus://awesome.pants/')
    end
  end
end
