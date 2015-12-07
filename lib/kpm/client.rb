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

        def get_osgi_logs(options = {})
          response = KillBillClient::API.get KILLBILL_OSGI_LOGGER_PREFIX, {}, options
          JSON.parse(response.body)
        end

        def install_plugin(name, version, type, filename, plugin, options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          KillBillClient::API.post path, plugin, {:name => name, :version => version, :type => type, :filename => filename}, options.merge(:content_type => 'application/octet-stream')
        end
      end

    end

  end
end
