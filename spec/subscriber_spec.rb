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
    before { TestSubscriber.subscribe }

    after do
      subscribers.each do |s|
        ::ActiveSupport::Notifications.unsubscribe(s)
      end
    end

    it 'adds subscribers for each event' do
      expect(subscribers.count).to eq events.count
      puts subscribers

      # verify that the listener registered for each event is actually the same
      # object as one in the subscribers list we got back
      events.each do |event|
        event_name = "#{event}.#{event_namespace}"
        listener = ::ActiveSupport::Notifications.notifier.listeners_for(event_name).first

        expect(subscribers).to include listener
      end
    end
  end
end
