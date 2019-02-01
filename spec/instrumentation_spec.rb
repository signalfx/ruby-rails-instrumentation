require 'spec_helper'

RSpec.describe Rails::Instrumentation do
  describe 'Class Methods' do
    it { is_expected.to respond_to :instrument }
    it { is_expected.to respond_to :add_subscribers }
  end
end
