require 'kpm/client'

module KPM
  class PluginsController < EngineController

    def index
      begin
        plugins = ::Killbill::KPM::KPMClient.get_available_plugins(true, options_for_klient)
      rescue => e
        # No connectivity, GitHub down, ...
        Rails.logger.warn("Unable to get latest plugins, trying built-in directory: #{e.inspect}")
        plugins = ::Killbill::KPM::KPMClient.get_available_plugins(false, options_for_klient)
      end

      @plugins = Hash[plugins.sort]
    end

  end
end
