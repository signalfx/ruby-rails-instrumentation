require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActiveRecordSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do
    before { tracer.spans.clear }

    describe 'sql' do
      statement = 'SELECT' * 4096
      let(:event) { ::ActiveSupport::Notifications::Event.new('sql.active_record', Time.now, Time.now, 0, sql: statement) }

      it 'adds tags' do
        described_class.sql(event)

        expected_keys = %w[db.statement name connection_id binds cached]
        span = tracer.spans.last
        check_span(expected_keys, span)
        expect(span.tags['db.statement']).to eq(statement[0..1023])
      end
    end

    describe 'instantiation' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('instantiation.active_record', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.instantiation(event)

        expected_keys = %w[record.count record.class]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
