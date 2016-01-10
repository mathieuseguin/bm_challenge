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

  get '*' do
    get_data(request)
  end

  post '*' do
    post_data(request)
  end
end
