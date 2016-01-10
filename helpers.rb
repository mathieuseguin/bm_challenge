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

      def call_api(request)
        uri = build_uri(request)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        method = request.env['REQUEST_METHOD']
        klass = Object.const_get('Net::HTTP::' + method.split('_').map(&:capitalize).join)
        req = klass.new(uri.request_uri)
        req.basic_auth ENV['API_USER'], ENV['API_PASS']
        req.set_form_data(normalize_params(request.env['rack.request.form_vars'])) if method == 'POST'

        res = http.request(req)

        if res.code == '200'
          res.body
        else
          halt res.code.to_i, res.to_hash, res.body
        end
      end

      def normalize_params(params)
        res = {}

        params.split('&').reject { |t| t =~ /]=$/ }.map do |param|
          k, v = param.split('=')
          v = URI.unescape(v)

          if res[k].nil?
            res[k] = v
          else
            if res[k].is_a?(Array)
              res[k] << v
            else
              res[k] = [res[k], v]
            end
          end
        end

        res
      end
    end
  end
end
