# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{provisional}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Cornick"]
  s.date = %q{2009-01-26}
  s.default_executable = %q{provisional}
  s.email = %q{mark@viget.com}
  s.executables = ["provisional"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/provisional", "lib/provisional/project.rb", "lib/provisional/scm", "lib/provisional/scm/git.rb", "lib/provisional/scm/svn.rb", "lib/provisional/scm/viget_git.rb", "lib/provisional/scm/viget_svn.rb", "lib/provisional/templates", "lib/provisional/templates/viget.rb", "lib/provisional/version.rb", "lib/provisional.rb", "test/test_helper.rb", "test/unit", "test/unit/git_test.rb", "test/unit/project_test.rb", "test/unit/svn_test.rb", "test/unit/viget_git_test.rb", "test/unit/viget_svn_test.rb", "bin/provisional"]
  s.has_rdoc = true
  s.homepage = %q{http://www.viget.com}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Automation for new Rails Projects}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<trollop>, [">= 1.10.2"])
    else
      s.add_dependency(%q<trollop>, [">= 1.10.2"])
    end
  else
    s.add_dependency(%q<trollop>, [">= 1.10.2"])
  end
end
