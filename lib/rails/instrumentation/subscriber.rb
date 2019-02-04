module Rails
  module Instrumentation
    module Subscriber
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def subscribe(exclude_events: [])
          @subscribers = []

          self::EVENTS.each do |event_name|
            full_name = "#{event_name}.#{self::EVENT_NAMESPACE}"

            next if exclude_events.include? full_name

            @subscribers << Utils.register_subscriber(full_name: full_name,
                                                      event_name: event_name,
                                                      handler_module: self)
          end
        end

        def unsubscribe
          @subscribers.each do |subscriber|
            ::ActiveSupport::Notifications.unsubscribe(subscriber)
          end
        end
      end
    end
  end
end
