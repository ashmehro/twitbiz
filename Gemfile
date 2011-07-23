source 'http://rubygems.org'

gem 'rails', '3.0.6'
gem 'rake', '0.8.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', :require => 'sqlite3'
gem 'twitter'

# this is used for initial authentication
gem 'oauth', :require => 'oauth'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

gem 'ruby-debug-ide19' #WORKS

gem 'jquery-rails'

#gem to install rqrcode gem - gem to encode QRcode
gem 'rqrcode', '0.3.4'
# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'webrat'
  gem 'mongrel', '1.2.0.pre2' #this is done because WEBRick can't handle Google OpenId long callback URLs
end
