# require 'active_support'

module Rails
  module Instrumentation
    module ActiveRecordSubscriber
      EVENT_NAMESPACE = 'active_record'.freeze

      EVENTS = %w[
        sql
        instantiation
      ].freeze

      class << self

        def subscribe
          @subscribers = ::Rails::Instrumentation::Subscriber.subscribe(EVENTS, EVENT_NAMESPACE, [])
        end
      end
    end
  end
end
