require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActionMailerSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do

    before { tracer.spans.clear }

    describe 'receive' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('receive.action_mailer', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.receive(event)

        expected_keys = %w[ mailer message.id message.subject message.to message.from message.bcc message.cc message.date message.body ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'deliver' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('deliver.action_mailer', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.deliver(event)

        expected_keys = %w[ mailer message.id message.subject message.to message.from message.bcc message.cc message.date message.body ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'process' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('process.action_mailer', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.process(event)

        expected_keys = %w[ mailer action args ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

  end
end
