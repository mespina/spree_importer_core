# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_importer_core'
  s.version     = '1.0.0'
  s.summary     = 'Import engine for Spree backend'
  s.description = 'Enables a easily way for massive load of different Spree models, depending as you need'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Marcelo Espina'
  s.email     = 'mespina.icc@gmail.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 3.0.0'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'

  # For file upload to read
  s.add_development_dependency 'paperclip', '~> 4.2'

  # For handling progress status
  s.add_development_dependency 'state_machine', '~> 1.2.0'

  # Roo provides an interface to Open Office, Excel, and Google Spreadsheets
  s.add_dependency 'roo'
end
