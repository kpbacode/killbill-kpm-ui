# frozen_string_literal: true

module KPM
  module ApplicationHelper
    # Return true if the KPM plugin is on at least one node
    # (INSTALL_PLUGIN and UNINSTALL_PLUGIN are handled by KPM plugin, not by the core)
    def kpm_plugin_installed?(nodes_info)
      nodes_info.each do |node_info|
        next if (node_info.plugins_info || []).empty?

        node_info.plugins_info.each do |plugin_info|
          return true if plugin_info.plugin_name == 'org.kill-bill.billing.killbill-platform-osgi-bundles-kpm'
        end
      end
      false
    end
  end
end
