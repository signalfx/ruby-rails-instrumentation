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

    def self.instrument(tracer: OpenTracing.global_tracer)
      @tracer = tracer
      @subscriber_mutex = Mutex.new

      add_subscribers
    end

    def self.add_subscribers
      @subscriber_mutex.synchronize do
        ActionControllerSubscriber.subscribe
        ActionViewSubscriber.subscribe
        ActiveRecordSubscriber.subscribe
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
