# frozen_string_literal: true

require 'ld-eventsource'

module Killbill
  module KPM
    class KPMClient < KillBillClient::Model::Resource
      KILLBILL_KPM_PREFIX = '/plugins/killbill-kpm'
      KILLBILL_OSGI_LOGGER_PREFIX = '/plugins/killbill-osgi-logger'

      class << self
        def get_available_plugins(kb_version, latest = true, options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          response = KillBillClient::API.get path, { :kbVersion => kb_version, :latest => latest }, options
          JSON.parse(response.body)
        end

        def stream_osgi_logs(writer, host, last_event_id_ref)
          url = host
          url = "http://#{url}" unless url.starts_with?('http:')
          SSE::Client.new(url + KILLBILL_OSGI_LOGGER_PREFIX, :last_event_id => last_event_id_ref.get, :logger => Rails.logger) do |client|
            client.on_event do |event|
              writer.write(event.data, :id => event.id)
              last_event_id_ref.set(event.id)
            end
          end
        end

        def install_plugin(key, version, type, filename, plugin, options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          KillBillClient::API.post path, plugin, { :key => key, :version => version, :type => type, :filename => filename }, options.merge(:content_type => 'application/octet-stream')
        end
      end
    end
  end
end
