require 'sinatra/base'

# :nodoc:
class StripeProxy < Sinatra::Base
  configure do
    set :server, :puma
    set :root, File.dirname(__FILE__)
  end

  get '/' do
    'Hello Baremetrics!'
  end
end
