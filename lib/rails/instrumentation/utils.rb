require 'active_support/notifications'

module Rails
  module Instrumentation
    module Utils
      class << self

        # calls a handler function with name 'event' on the handler module.
        # For example, if the handler module is ActionViewSubscriber and the
        # event hook is 'render_template.action_controller', full_name is
        # 'render_template.action_controller' and event_name is 'render_template'
        def register_subscriber(full_name: '', event_name: '', handler_module: nil)
          ::ActiveSupport::Notifications.subscribe(full_name) do |*args|
            event = ::ActiveSupport::Notifications::Event.new(*args)
            handler_module.send(event_name, event)
          end
        end

        # takes and event and some set of tags from a handler, and creates a
        # span with the event's name and the start and finish times.
        def trace_notification(event:, tags: [])
          span = ::Rails::Instrumentation.tracer.start_span(event.name,
                                                            tags: tags,
                                                            start_time: event.time)

          span.finish(end_time: event.end)
        end
      end
    end
  end
end
