require 'ld-eventsource'

module Killbill
  module KPM

    class KPMClient < KillBillClient::Model::Resource

      KILLBILL_KPM_PREFIX = '/plugins/killbill-kpm'
      KILLBILL_OSGI_LOGGER_PREFIX = '/plugins/killbill-osgi-logger'

      class << self

        def get_available_plugins(latest=true, options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          response = KillBillClient::API.get path, { :latest => latest }, options
          JSON.parse(response.body)
        end

        def stream_osgi_logs(writer, options = {})
          SSE::Client.new(KillBillClient::API.base_uri + KILLBILL_OSGI_LOGGER_PREFIX) do |client|
            client.on_event do |event|
              writer.write(event.data)
            end
          end
        end

        def install_plugin(key, version, type, filename, plugin, options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          KillBillClient::API.post path, plugin, {:key => key, :version => version, :type => type, :filename => filename}, options.merge(:content_type => 'application/octet-stream')
        end
      end

    end

  end
end
