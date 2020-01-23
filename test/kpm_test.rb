# frozen_string_literal: true

require 'test_helper'

class KPMTest < ActiveSupport::TestCase
  test 'can load KPM module' do
    assert_kind_of Module, KPM
  end
end
