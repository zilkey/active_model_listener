# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{active_model_listener}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeff Dean"]
  s.date = %q{2009-10-03}
  s.email = %q{jeff@zilkey.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.homepage = %q{http://github.com/zilkey/active_model_listener}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{Simple, global ActiveRecord event observers, using a middleware architecture, that can easily be turned on and off.  Designed for audit trails, activity feeds and other app-level event handlers}
  s.test_files = [
    "spec/active_model_listener_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end