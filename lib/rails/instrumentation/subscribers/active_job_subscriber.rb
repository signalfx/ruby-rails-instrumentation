module Rails
  module Instrumentation
    module ActiveJobSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'active_job'.freeze

      EVENTS = %w[
        enqueue_at
        enqueue
        perform_start
        perform
      ].freeze

      class << self
        def enqueue_at(event)
          tags = {
            'adapter' => event.payload[:adapter],
            'job' => event.payload[:job]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def enqueue(event)
          tags = {
            'adapter' => event.payload[:adapter],
            'job' => event.payload[:job]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def perform_start(event)
          tags = {
            'adapter' => event.payload[:adapter],
            'job' => event.payload[:job]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def perform(event)
          tags = {
            'adapter' => event.payload[:adapter],
            'job' => event.payload[:job]
          }

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
