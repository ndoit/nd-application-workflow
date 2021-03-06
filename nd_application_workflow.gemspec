$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "nd_application_workflow/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nd_application_workflow"
  s.version     = NdApplicationWorkflow::VERSION
  s.authors     = ["Teresa Meyer"]
  s.email       = ["tmeyer2@nd.edu"]
  s.homepage    = "https://bitbucket.org/nd-oit/nd-application-workflow"
  s.summary     = "Notification and approval workflow framework for ND applications"
  s.description = "Provides default migrations, view partials, javascript, css for notification and approval workflows to ND active employees for ND applications"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.9"
  s.add_dependency "jquery-rails", "~> 4.2.1"
  s.add_dependency "foundation-rails", "~> 5.4.3.0"
  s.add_dependency "workflow"
  s.add_development_dependency "sqlite3", '~> 1.3.11'
  s.add_development_dependency 'rspec-rails', '~> 3.5.0'
  s.add_development_dependency 'capybara', '~> 2.7.1'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1.1'
end
