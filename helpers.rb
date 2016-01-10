module Sinatra
  module StripeProxy
    module Helpers
      def build_uri(request)
        URI::HTTPS.build(
          port: ENV['API_PORT'].to_i,
          host: ENV['API_HOST'],
          path: request.path_info,
          query: request.query_string
        )
      end

      def get_data(request)
        uri = build_uri(request)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Get.new(uri.request_uri)
        req.basic_auth ENV['API_USER'], ENV['API_PASS']

        res = http.request(req)

        if res.code == '200'
          res.body
        else
          halt res.code.to_i
        end
      end

      def post_data(request)
        uri = build_uri(request)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data(request.params)
        req.basic_auth ENV['API_USER'], ENV['API_PASS']

        res = http.request(req)

        if res.code == '200'
          res.body
        else
          halt res.code.to_i
        end
      end
    end
  end
end
