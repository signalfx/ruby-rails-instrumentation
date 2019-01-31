require 'active_support'

module Rails
  module Instrumentation
    module Subscriber

      def self.subscribe_list(event_list, event_namespace, tag_list)
        subscribers = []

        event_list.each do |event|
          subscriber = ::ActiveSupport::Notifications.subscribe("#{event}.#{event_namespace}") do |*args|
            ::Rails::Instrumentation.trace_notification(args, tag_list: tag_list)
          end

          subscribers << subscriber
        end # event_list.each

        subscribers
      end # subscribe

      def self.subscribe(event_name, payload_tags)
        ::ActiveSupport::Notifications.subscribe(event_name) do |*args|
          ::Rails::Instrumentation.trace_notification(args, payload_tags: payload_tags)
        end
      end
    end
  end
end
