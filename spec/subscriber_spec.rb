require 'spec_helper'

RSpec.describe Rails::Instrumentation::Subscriber do

  let(:tracer) { OpenTracingTestTracer.build }
  let(:events) { %w[ test_event_1 test_event_2 test_event_3 ] }
  let(:event_namespace) { 'subscriber_test' }
  let(:tags) { %w[ status_code response errors ] }

  describe 'Class Methods' do
    it { is_expected.to respond_to :subscribe }
  end

  describe 'subscribe' do
    let(:subscribers) { described_class.subscribe(events, event_namespace, tags) }
    
    it 'adds subscribers for each event' do
      expect(subscribers.count).to eq events.count

      # verify that the listener registered for each event is actually the same
      # object as one in the subscribers list we got back
      events.each do |event|
        event_name = "#{event}.#{event_namespace}"
        listener = ::ActiveSupport::Notifications.notifier.listeners_for(event_name).first

        expect(subscribers).to include listener
      end
    end

    it 'passes the tags list to the trace_notification handler' do
      allow(::Rails::Instrumentation).to receive(:trace_notification)

      # pick one of the events and trigger it
      ::ActiveSupport::Notifications.instrument("#{events[1]}.#{event_namespace}") do
        # some work
      end

      # check that tag list is passed in
      expect(::Rails::Instrumentation).to have_received(:trace_notification).with(anything, tags)
    end
  end
end
