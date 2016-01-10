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
        http = ::Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        method = request.env['REQUEST_METHOD']
        klass = ::Object.const_get('Net::HTTP::' + method.split('_').map(&:capitalize).join)

        req = klass.new(uri.request_uri)
        req.basic_auth ENV['API_USER'], ENV['API_PASS']

        if method == 'POST'
          req.set_form_data(normalize_params(request.env['rack.request.form_vars']))
        end

        res = http.request(req)

        if res.code == '200'
          res.body
        else
          halt res.code.to_i, res.to_hash, res.body
        end
      end

      def cache(url)
        data = get_from_cache(url)

        unless data
          data = yield
          save_to_cache(url, data)
        end

        data
      end

      def get_from_cache(url)
        settings.conn.exec "SELECT * FROM cache WHERE url = '#{url}' LIMIT 1" do |result|
          return result.any? ? result.first.values_at('data').first : false
        end
      rescue
        false
      end

      def save_to_cache(url, data)
        settings.conn.exec "INSERT INTO cache VALUES ('#{url}', '#{data}')"
      rescue
        false
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
