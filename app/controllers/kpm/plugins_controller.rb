# frozen_string_literal: true

require 'kpm/client'

module KPM
  class PluginsController < EngineController
    def index
      nodes_by_kb_version, @kb_version = killbill_version
      @warning_message = ''
      plugins = []
      if nodes_by_kb_version.size > 1
        @warning_message = different_versions_warning_message(nodes_by_kb_version)
      else
        begin
          plugins = ::Killbill::KPM::KPMClient.get_available_plugins(true, options_for_klient)
        rescue StandardError => e
          # No connectivity, GitHub down, ...
          Rails.logger.warn("Unable to get latest plugins, trying built-in directory: #{e.inspect}")
          plugins = ::Killbill::KPM::KPMClient.get_available_plugins(false, options_for_klient)
        end
        plugins.select! { |_plugin_key, info| info['versions'].keys.include?(@kb_version) }
      end
      @plugins = Hash[plugins.sort]
    end

    private

    def different_versions_warning_message(nodes_by_kb_version)
      message = '<b>Warning!</b> Unable to find plugins to install, different versions of Kill Bill were found:<ul>'
      nodes_by_kb_version.each do |version, node_name|
        message = "#{message} <li><b>#{version}:</b> #{node_name}</li>"
      end
      "#{message}</ul>"
    end

    def killbill_version
      nodes_info = ::KillBillClient::Model::NodesInfo.nodes_info(options_for_klient)
      return nil if nodes_info.blank?

      first_node_version = nodes_info.first.kb_version
      nodes_by_kb_version = {}
      nodes_info.each do |node|
        nodes_by_kb_version[node.kb_version] = "#{(nodes_by_kb_version[node.kb_version] || '')} #{node.node_name}"
      end
      [nodes_by_kb_version, first_node_version.scan(/(\d+\.\d+)(\.\d)?/).flatten[0]]
    end
  end
end
