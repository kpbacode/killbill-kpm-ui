KPM::Engine.routes.draw do

  root to: 'nodes_info#index'

  resources :nodes_info, :only => [:index]

  scope '/nodes_info' do
    match '/plugin/install' => 'nodes_info#install_plugin', :via => :post, :as => 'plugin_install'
    match '/plugin/uninstall' => 'nodes_info#uninstall_plugin', :via => :post, :as => 'plugin_uninstall'
    match '/plugin/start' => 'nodes_info#start_plugin', :via => :post, :as => 'plugin_start'
    match '/plugin/stop' => 'nodes_info#stop_plugin', :via => :post, :as => 'plugin_stop'
    match '/plugin/restart' => 'nodes_info#restart_plugin', :via => :post, :as => 'plugin_restart'
  end

end
