require 'spec_helper'

RSpec.describe Rails::Instrumentation::Utils do
  let(:name) { TestSubscriber::EVENTS.first }
  let(:namespace) { TestSubscriber::EVENT_NAMESPACE }
  let(:full_name) { "#{name}.#{namespace}" }
  let(:tags) { { 'status_code' => 200, 'response' => 'success', 'errors' => 0 } }

  describe 'Class Methods' do
    it { is_expected.to respond_to :register_subscriber }
    it { is_expected.to respond_to :trace_notification }
  end

  describe 'register_subscriber' do

    before do
      @subscriber = described_class.register_subscriber(full_name: full_name,
                                                        event_name: name,
                                                        handler_module: TestSubscriber)
    end

    after { ::ActiveSupport::Notifications.unsubscribe(@subscriber) }

    it 'adds a subscriber for the event' do
      expect(@subscriber).not_to be nil

      # verify that the listener registered for the event is actually the same
      # object as the subscriber we got back
      listener = ::ActiveSupport::Notifications.notifier.listeners_for(full_name).first

      expect(@subscriber).to eq listener
    end

    it 'calls the correct :event_name method in the handler' do
      # it should call the method 'test_event_1' in the TestSubscriber
      expect(TestSubscriber).to receive(name)

      # trigger the event
      ::ActiveSupport::Notifications.instrument(full_name) do
        # some work
      end
    end

  end

  describe 'trace_notification' do
    let(:tracer) { OpenTracingTestTracer.build }
    let(:event) { ::ActiveSupport::Notifications::Event.new(name, Time.now, Time.now, 0, {})}

    before do
      # allow the spans to be collected in our test tracer
      allow(::Rails::Instrumentation).to receive(:tracer).and_return(tracer)

      described_class.trace_notification(event: event, tags: tags)
    end

    it 'adds a span with tags' do
      expect(tracer.spans.count).to eq 1
      expect(tracer.spans.last.tags).to eq tags
    end
  end

  describe 'tag_error' do
    let(:tracer) { OpenTracingTestTracer.build }
    let(:span) { tracer.start_span('test_span', tags: {}) }
    let(:exception) { Exception.new('error_message') }
    let(:payload) { {:exception => ['Exception', 'message'], :exception_object => exception} }

    before { described_class.tag_error(span, payload) }

    it 'adds error tags and logs to the span' do
      expect(span.tags['error']).to be true

      kind_log = {
        :key => 'error.kind',
        :value => 'Exception',
        :timestamp => anything
      }
      expect(span.logs).to include kind_log

      message_log = {
        :key => 'message',
        :value => 'message',
        :timestamp => anything
      }
      expect(span.logs).to include message_log

      object_log = {
        :key => 'error.object',
        :value => exception,
        :timestamp => anything
      }
      expect(span.logs).to include object_log
    end
  end
end
