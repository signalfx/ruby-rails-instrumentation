require 'rails/instrumentation/version'
require 'rails/instrumentation/subscriber'
require 'rails/instrumentation/subscribers/action_controller_subscriber'
require 'rails/instrumentation/subscribers/action_view_subscriber'
require 'rails/instrumentation/subscribers/active_record_subscriber'
require 'rails/instrumentation/subscribers/active_support_subscriber'
require 'rails/instrumentation/subscribers/action_mailer_subscriber'
require 'rails/instrumentation/subscribers/active_job_subscriber'
require 'rails/instrumentation/subscribers/action_cable_subscriber'
require 'rails/instrumentation/subscribers/active_storage_subscriber'
require 'rails/instrumentation/utils'

require 'opentracing'

module Rails
  module Instrumentation
    class Error < StandardError; end

    TAGS = {
      'component' => 'ruby-rails',
      'instrumentation.version' => Rails::Instrumentation::VERSION
    }.freeze

    def self.instrument(tracer: OpenTracing.global_tracer,
                        exclude_events: [])
      @tracer = tracer

      add_subscribers(exclude_events: exclude_events)
    end

    def self.tracer
      @tracer
    end

    def self.add_subscribers(exclude_events: [])
      ActiveRecordSubscriber.subscribe(exclude_events: exclude_events)
      ActionControllerSubscriber.subscribe(exclude_events: exclude_events)
      ActionViewSubscriber.subscribe(exclude_events: exclude_events)
      ActiveSupportSubscriber.subscribe(exclude_events: exclude_events)
      ActionMailerSubscriber.subscribe(exclude_events: exclude_events)
      ActiveJobSubscriber.subscribe(exclude_events: exclude_events)
      ActionCableSubscriber.subscribe(exclude_events: exclude_events)
      ActiveStorageSubscriber.subscribe(exclude_events: exclude_events)
    end
    private_class_method :add_subscribers

    def self.uninstrument
      ActiveRecordSubscriber.unsubscribe
      ActionControllerSubscriber.unsubscribe
      ActionViewSubscriber.unsubscribe
      ActiveSupportSubscriber.unsubscribe
      ActionMailerSubscriber.unsubscribe
      ActiveJobSubscriber.unsubscribe
      ActionCableSubscriber.unsubscribe
      ActiveStorageSubscriber.unsubscribe
    end
  end
end
