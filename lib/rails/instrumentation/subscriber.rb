
module Rails
  module Instrumentation
    module Subscriber
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def subscribe(exclude_list: [])
          @subscribers = []

          self::EVENTS.each do |event_name|
            full_name = "#{event_name}.#{self::EVENT_NAMESPACE}"

            @subscribers << Utils.register_subscriber(full_name: full_name,
                                                      event_name: event_name,
                                                      handler_module: self)
          end
        end
      end
    end
  end
end
