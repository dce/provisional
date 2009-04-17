# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{provisional}
  s.version = "2.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Cornick"]
  s.date = %q{2009-04-16}
  s.default_executable = %q{provisional}
  s.email = %q{markk@viget.com}
  s.executables = ["provisional"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "VERSION.yml", "bin/provisional", "lib/provisional", "lib/provisional/project.rb", "lib/provisional/scm", "lib/provisional/scm/git.rb", "lib/provisional/scm/github.rb", "lib/provisional/templates", "lib/provisional/templates/viget.rb", "lib/provisional.rb", "test/test_helper.rb", "test/unit", "test/unit/git_test.rb", "test/unit/github_test.rb", "test/unit/project_test.rb"]
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
      s.add_runtime_dependency(%q<trollop>, [">= 1.10.2"])
      s.add_runtime_dependency(%q<rails>, [">= 2.3.0"])
      s.add_runtime_dependency(%q<git>, [">= 1.0.5"])
    else
      s.add_dependency(%q<trollop>, [">= 1.10.2"])
      s.add_dependency(%q<rails>, [">= 2.3.0"])
      s.add_dependency(%q<git>, [">= 1.0.5"])
    end
  else
    s.add_dependency(%q<trollop>, [">= 1.10.2"])
    s.add_dependency(%q<rails>, [">= 2.3.0"])
    s.add_dependency(%q<git>, [">= 1.0.5"])
  end
end
