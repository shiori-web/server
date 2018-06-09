source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.0'

gem 'rails', '~> 5.2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'

gem 'redis', '~> 4.0'
gem 'sidekiq', '~> 5.1.3'
gem 'bcrypt', '~> 3.1.7'
gem 'mini_magick', '~> 4.8'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'rack-cors', '~> 1.0.2'
gem 'pundit', '~> 1.1.0'
gem 'rolify', '~> 5.2.0'
gem 'doorkeeper', '~> 4.3.2'

gem 'friendly_id', '~> 5.1.0'
gem 'jsonapi-utils', '~> 0.7.2'
gem 'jsonapi-authorization', '~> 1.0.0.alpha6'

group :development, :test do
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'letter_opener'
end

group :development do
  gem 'spring'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
