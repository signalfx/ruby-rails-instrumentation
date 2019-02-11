require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActionCableSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do
    before { tracer.spans.clear }

    describe 'perform_action' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('perform_action.action_cable', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.perform_action(event)

        expected_keys = %w[channel_class action data]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'transmit' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('transmit.action_cable', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.transmit(event)

        expected_keys = %w[channel_class data via]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'transmit_subscription_confirmation' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('transmit_subscription_confirmation.action_cable', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.transmit_subscription_confirmation(event)

        expected_keys = %w[channel_class]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'transmit_subscription_rejection' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('transmit_subscription_rejection.action_cable', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.transmit_subscription_rejection(event)

        expected_keys = %w[channel_class]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'broadcast' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('broadcast.action_cable', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.broadcast(event)

        expected_keys = %w[broadcasting message coder]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
