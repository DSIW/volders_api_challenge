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
  gem 'rubocop', '~> 0.52'
  gem 'rack-test', '~> 0.8'
  gem 'guard', '~> 2.14'
  gem 'guard-rspec', '~> 4.7'
  gem 'guard-cucumber', '~> 2.1'
  gem 'cucumber', '~> 2.4' # 2.X is required by guard-cucumber
end

group :production do
  # gem 'puma'
end
