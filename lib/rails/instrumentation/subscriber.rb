module Rails
  module Instrumentation
    module Subscriber
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def subscribe(exclude_events: [])
          @subscriber_mutex = Mutex.new if @subscriber_mutex.nil?

          # clear
          unsubscribe
          @subscribers = []

          @subscriber_mutex.synchronize do
            self::EVENTS.each do |event_name|
              full_name = "#{event_name}.#{self::EVENT_NAMESPACE}"

              next if exclude_events.include? full_name

              @subscribers << Utils.register_subscriber(full_name: full_name,
                                                        event_name: event_name,
                                                        handler_module: self)
            end
          end
        end

        def unsubscribe
          return if @subscribers.nil? || @subscriber_mutex.nil?

          @subscriber_mutex.synchronize do
            @subscribers.each do |subscriber|
              ::ActiveSupport::Notifications.unsubscribe(subscriber)
            end
          end
        end

        def span_tags(tags)
          self::BASE_TAGS.clone.merge(tags)
        end
      end
    end
  end
end
