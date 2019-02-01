require 'rails/instrumentation/version'
require 'rails/instrumentation/subscriber'
require 'rails/instrumentation/subscribers/action_controller_subscriber'
require 'rails/instrumentation/subscribers/action_view_subscriber'
require 'rails/instrumentation/subscribers/active_record_subscriber'
require 'rails/instrumentation/utils'

require 'opentracing'

module Rails
  module Instrumentation
    class Error < StandardError; end

    attr_accessor :tracer

    def self.instrument(tracer: OpenTracing.global_tracer,
                        exclude_events: [])
      @tracer = tracer
      @subscriber_mutex = Mutex.new

      add_subscribers(exclude_events: exclude_events)
    end

    def self.tracer
      @tracer
    end

    def self.add_subscribers(exclude_events: [])
      @subscriber_mutex.synchronize do
        ActiveRecordSubscriber.subscribe(exclude_events: exclude_events)
        ActionControllerSubscriber.subscribe(exclude_events: exclude_events)
        ActionViewSubscriber.subscribe(exclude_events: exclude_events)
      end
    end
    private_class_method :add_subscribers

    def self.clear_subscribers
      @subscriber_mutex.synchronize do
        # todo
      end
    end
    private_class_method :clear_subscribers
  end
end
