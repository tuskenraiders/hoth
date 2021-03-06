require 'rack/request'
require 'json'

module Hoth
  module Providers
    class RackProvider

      def initialize(app)
        @app = app
      end

      def call(env)
        if env["PATH_INFO"] =~ /^\/execute/
          begin
            req = Rack::Request.new(env)

            service_name, service_params = req.params.values_at('name', 'params')
            decoded_params = Hoth::Transport::JsonTransport.decode_params(service_params)
            Hoth::Logger.debug "decoded_params: #{decoded_params.inspect}"
            result = Hoth::Services.__send__(service_name, *decoded_params)
            json_payload   = JSON({"result" => result })
          
            [200, {'Content-Type' => 'application/json'}, [ json_payload ] ]
          rescue Exception => e
            if service = Hoth::ServiceRegistry.locate_service(service_name) rescue nil
              e.source_endpoint = service.endpoint.name
            end
            Hoth::Logger.error e # log locally first, then transfer over http
            json_payload = JSON({'error' => e})
            [500, {'Content-Type' => 'application/json'}, [ json_payload ] ]
          end
        else
          @app.call(env)
        end
      end
    end
  end
end
