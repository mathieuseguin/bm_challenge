require 'rack/test'
require 'rspec'
require 'webmock/rspec'
require 'json'

ENV['RACK_ENV'] = 'test'

ENV['API_HOST'] ||= 'api.stripe.com'
ENV['API_PORT'] ||= '443'
ENV['API_USER'] ||= 'sk_test_BQokikJOvBiI2HlWgH4olfQ2'
ENV['API_PASS'] ||= ''
ENV['DATABASE_URL'] ||= 'postgres://localhost/bm_test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    StripeProxy
  end
end

RSpec.configure do |c|
  c.include RSpecMixin
  c.filter_run_including focus: true
  c.run_all_when_everything_filtered = true

  c.before do
    @conn = PG.connect(ENV['DATABASE_URL'])
  end

  c.around do |example|
    if example.metadata[:with_webmock]
      WebMock.enable!
    else
      WebMock.disable!
    end

    example.run

    WebMock.disable!
  end

  c.after do
    @conn.exec 'TRUNCATE cache;'
    @conn.close
  end
end
