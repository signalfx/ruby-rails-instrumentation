require 'spec_helper'

RSpec.describe Rails::Instrumentation::Subscriber do
  let(:events) { TestSubscriber::EVENTS }
  let(:event_namespace) { TestSubscriber::EVENT_NAMESPACE }

  describe 'Class extended with Subscriber methods' do
    it 'responds to :subscribe' do
      expect(TestSubscriber).to respond_to :subscribe
    end
  end

  describe 'subscribe' do
    let(:subscribers) { TestSubscriber.subscribers }

    after do
      subscribers.each do |s|
        ::ActiveSupport::Notifications.unsubscribe(s)
      end
    end

    it 'adds subscribers for each event' do
      TestSubscriber.subscribe

      expect(subscribers.count).to eq events.count

      # verify that the listener registered for each event is actually the same
      # object as one in the subscribers list we got back
      events.each do |event|
        event_name = "#{event}.#{event_namespace}"
        listener = ::ActiveSupport::Notifications.notifier.listeners_for(event_name).first

        expect(subscribers).to include listener
      end
    end

    it 'doesn\'t create subscribers for events in the exclude list' do
      exclude_events = [ 'test_event_1.test_subscriber', 'test_event_3.test_subscriber' ]
      TestSubscriber.subscribe(exclude_events: exclude_events)

      expect(subscribers.count).to eq (events.count - exclude_events.count)

      # there should only be a listener for 'test_event_2'
      listener = ::ActiveSupport::Notifications.notifier.listeners_for('test_event_2.test_subscriber').first
      expect(subscribers.first).to eq listener
    end
  end
end
