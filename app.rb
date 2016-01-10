require 'sinatra/base'
require 'pg'

require_relative 'helpers'

class StripeProxy < Sinatra::Base
  configure do
    set :server, :puma
    set :root, File.dirname(__FILE__)
    set :conn, ::PG.connect(ENV['DATABASE_URL'])
    helpers Sinatra::StripeProxy::Helpers
  end

  before do
    content_type :json
  end

  get '/:version/events' do
    cache(url) do
      call_api(request)
    end
  end

  get '/:version/events/:id' do
    cache(url) do
      call_api(request)
    end
  end

  %w(get post delete).each do |method|
    send(method, '*') do
      call_api(request)
    end
  end
end
