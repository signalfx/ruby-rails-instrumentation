module Rails
  module Instrumentation
    module ActionCableSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'action_cable'.freeze

      EVENTS = %w[
        perform_action
        transmit
        transmit_subscription_confirmation
        transmit_subscription_rejection
        broadcast
      ].freeze

      class << self
        def perform_action(event)
          tags = {
            'channel_class' => event.payload[:channel_class],
            'action' => event.payload[:action],
            'data' => event.payload[:data]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def transmit(event)
          tags = {
            'channel_class' => event.payload[:channel_class],
            'data' => event.payload[:data],
            'via' => event.payload[:via]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def transmit_subscription_confirmation(event)
          tags = {
            'channel_class' => event.payload[:channel_class]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def transmit_subscription_rejection(event)
          tags = {
            'channel_class' => event.payload[:channel_class]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def broadcast(event)
          tags = {
            'broadcasting' => event.payload[:broadcasting],
            'message' => event.payload[:message],
            'coder' => event.payload[:coder]
          }

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
