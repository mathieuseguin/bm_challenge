require 'sinatra/base'

require_relative 'helpers'

class StripeProxy < Sinatra::Base
  configure do
    set :server, :puma
    set :root, File.dirname(__FILE__)
    helpers Sinatra::StripeProxy::Helpers
  end

  before do
    content_type :json
  end

  %w(get post delete).each do |method|
    send(method, '*') do
      call_api(request)
    end
  end
end
