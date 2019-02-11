require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActiveJobSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do
    before { tracer.spans.clear }

    describe 'enqueue_at' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('enqueue_at.active_job', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.enqueue_at(event)

        expected_keys = %w[adapter job]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'enqueue' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('enqueue.active_job', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.enqueue(event)

        expected_keys = %w[adapter job]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'perform_start' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('perform_start.active_job', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.perform_start(event)

        expected_keys = %w[adapter job]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'perform' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('perform.active_job', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.perform(event)

        expected_keys = %w[adapter job]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
