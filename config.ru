require 'rubygems'
require 'bundler'

Bundler.require

ENV['API_HOST'] ||= 'api.stripe.com'
ENV['API_PORT'] ||= '443'
ENV['API_USER'] ||= 'sk_test_BQokikJOvBiI2HlWgH4olfQ2'
ENV['API_PASS'] ||= ''
ENV['DATABASE_URL'] ||= 'postgres://localhost/bm_development'

require './app'
run StripeProxy
