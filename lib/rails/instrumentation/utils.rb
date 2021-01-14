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
          tags = ::Rails::Instrumentation::TAGS.clone.merge(tags)

          span = ::Rails::Instrumentation.tracer.start_span(event.name,
                                                            tags: tags,
                                                            start_time: event.time)

          # tag transaction_id
          span.set_tag('transaction.id', event.transaction_id)
          tag_error(span, event.payload) if event.payload.key? :exception

          span.finish(end_time: event.end)
        end

        # according to the ActiveSupport::Notifications documentation, exceptions
        # will be indicated with the presence of the :exception and :exception_object
        # keys. These will be tagged and logged according to the OpenTracing
        # specification.
        def tag_error(span, payload)
          if payload.key? :exception_object
            span.record_exception(payload[:exception_object])
          else
            exception = payload[:exception]
            span.set_tag(:error, true)
            span.set_tag(:'sfx.error.kind', exception[0]) 
            span.set_tag(:'sfx.error.message', exception[1])
          end
        end
      end
    end
  end
end
