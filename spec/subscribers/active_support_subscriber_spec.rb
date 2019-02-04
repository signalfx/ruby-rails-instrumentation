require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActiveSupportSubscriber do

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end
end
