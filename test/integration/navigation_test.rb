# frozen_string_literal: true

require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  include KPM::Engine.routes.url_helpers

  test 'can see the nodes info page' do
    get '/kpm'
    assert_response :success
  end

  test 'can restart bundle' do
    post '/kpm/nodes_info/plugin/restart?plugin_name=org.apache.felix.shell'
    assert_response :success
  end
end
