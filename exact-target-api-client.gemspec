# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{exact-target-api-client}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Craig Israel"]
  s.date = %q{2011-07-14}
  s.email = %q{craig.israel@healthways.com}
  s.homepage = %q{http://www.vitalitycity.com}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Ruby client for ExactTarget SOAP api}

  s.add_dependency('delayed_job')
  s.add_dependency('savon', '~> 0.9.1')

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
