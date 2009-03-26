# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{provisional}
  s.version = "1.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Cornick"]
  s.date = %q{2009-03-26}
  s.email = %q{markk@viget.com}
  s.executables = ["provisional", "provisional-github-helper"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/provisional", "bin/provisional-github-helper", "lib/provisional", "lib/provisional/project.rb", "lib/provisional/scm", "lib/provisional/scm/git.rb", "lib/provisional/scm/github.rb", "lib/provisional/scm/svn.rb", "lib/provisional/scm/viget_git.rb", "lib/provisional/scm/viget_svn.rb", "lib/provisional/templates", "lib/provisional/templates/viget.rb", "lib/provisional.rb", "test/test_helper.rb", "test/unit", "test/unit/git_test.rb", "test/unit/github_test.rb", "test/unit/project_test.rb", "test/unit/svn_test.rb", "test/unit/viget_git_test.rb", "test/unit/viget_svn_test.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/vigetlabs/provisional}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{viget}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automation for new Rails Projects}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
