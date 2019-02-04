require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActionViewSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do

    before { tracer.spans.clear }

    describe 'render_template' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('render_template.action_view', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.render_template(event)

        expected_keys = %w[ template.identifier template.layout ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'render_partial' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('render_partial.action_view', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.render_partial(event)

        expected_keys = %w[ partial.identifier ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'render_collection' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('render_collection.action_view', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.render_collection(event)

        expected_keys = %w[ template.identifier template.count ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

  end
end
