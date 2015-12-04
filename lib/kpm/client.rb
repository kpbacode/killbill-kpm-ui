module Killbill
  module KPM

    class KPMClient < KillBillClient::Model::Resource

      KILLBILL_KPM_PREFIX = '/plugins/killbill-kpm'
      KILLBILL_OSG_LOGGER_PREFIX = '/plugins/killbill-osgi-logger'

      class << self

        def get_available_plugins(options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          response = KillBillClient::API.get path, {}, options
          JSON.parse(response.body)
        end

        def get_osgi_logs(options = {})
          response = KillBillClient::API.get KILLBILL_OSG_LOGGER_PREFIX, {}, options
          JSON.parse(response.body)
        end
      end

    end

  end
end
