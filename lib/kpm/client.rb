module Killbill
  module KPM

    class KPMClient < KillBillClient::Model::Resource

      KILLBILL_KPM_PREFIX = '/plugins/killbill-kpm'

      class << self

        def get_available_plugins(options = {})
          path = "#{KILLBILL_KPM_PREFIX}/plugins"
          response = KillBillClient::API.get path, {}, options
          JSON.parse(response.body)
        end

      end

    end

  end
end
