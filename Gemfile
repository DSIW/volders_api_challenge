source 'https://rubygems.org'

ruby '2.4.1'

gem 'rake'
gem 'hanami',       '~> 1.1'
gem 'hanami-model', '~> 1.1'

gem 'sqlite3', '~> 1.3'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun'
  gem 'yard', '~> 0.9'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
  gem 'pry', '~> 0.11'
end

group :test do
  gem 'rspec'
  gem 'simplecov', '~> 0.15'
  gem 'cucumber', '~> 3.1'
  gem 'rubocop', '~> 0.52'
end

group :production do
  # gem 'puma'
end
