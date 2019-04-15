source 'https://rubygems.org'

gem 'dry-system'
gem 'dry-system-hanami', github: 'davydovanton/dry-system-hanami'
gem 'hanami',       '~> 1.3'
gem 'hanami-validations', '1.3.3'
# gem 'hanami-model'

gem 'pg'
gem 'rake'
gem 'slim'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'rspec'
  gem 'capybara'
end

group :production do
  # gem 'puma'
end
