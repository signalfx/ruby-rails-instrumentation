require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActionViewSubscriber do

  describe 'Class Methods' do
    it 'responds to all event methods' do
      described_class::EVENTS.each do |event|
        expect(described_class).to respond_to event
      end
    end
  end
end
