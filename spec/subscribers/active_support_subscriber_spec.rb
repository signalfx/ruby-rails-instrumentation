require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActiveSupportSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do
    before { tracer.spans.clear }

    describe 'cache_read' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_read.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_read(event)

        expected_keys = %w[key hit super_operation]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'cache_generate' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_generate.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_generate(event)

        expected_keys = %w[key]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'cache_fetch_hit' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_fetch_hit.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_fetch_hit(event)

        expected_keys = %w[key]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'cache_write' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_write.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_write(event)

        expected_keys = %w[key]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'cache_delete' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_delete.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_delete(event)

        expected_keys = %w[key]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'cache_exist?' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('cache_exist?.active_support', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.cache_exist?(event)

        expected_keys = %w[key]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
