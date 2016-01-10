require 'rack/test'
require 'rspec'
require 'json'

ENV['RACK_ENV'] = 'test'

ENV['API_HOST'] ||= 'api.stripe.com'
ENV['API_PORT'] ||= '443'
ENV['API_USER'] ||= 'sk_test_BQokikJOvBiI2HlWgH4olfQ2'
ENV['API_PASS'] ||= ''

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    StripeProxy
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
end
