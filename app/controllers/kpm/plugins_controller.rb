require 'kpm/client'

module KPM
  class PluginsController < EngineController

    def index
      plugins = ::Killbill::KPM::KPMClient.get_available_plugins(options_for_klient)
      @plugins = Hash[plugins.sort]
    end

  end
end
