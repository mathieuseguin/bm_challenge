source 'https://rubygems.org'

gem 'sinatra'
gem 'puma'

group :development do
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'guard-rubocop', require: false
end

group :test, :development do
  gem 'rspec'
  gem 'rubocop', require: false
end

group :test do
  gem 'rack-test'
end
