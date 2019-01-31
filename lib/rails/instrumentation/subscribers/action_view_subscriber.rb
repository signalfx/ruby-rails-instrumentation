
module Rails
  module Instrumentation
    module ActionViewSubscriber
      EVENT_NAMESPACE = 'action_view'.freeze

      EVENTS = %w[
        render_template
        render_partial
        render_collection
      ]

      class << self

        def subscribe(exclude_list: [])
          @subscribers = []

          EVENTS.each do |event_name|
            full_name = "#{event_name}.#{EVENT_NAMESPACE}"

            @subscribers << Utils.register_subscriber(full_name: full_name,
                                                      event_name: event_name,
                                                      handler_module: self)
          end
        end

        def render_template(event)
          tags = {
            'template.identifier' => event.payload[:identifier],
            'template.layout' => event.payload[:layout]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def render_partial(event)
          tags = {
            'partial.identifier' => event.payload[:identifier]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def render_collection(event)
          tags = {
            'template.identifier' => event.payload[:identifier],
            'template.count' => event.payload[:count]
          }
          tags['template.cache_hits'] = event.payload[:cache_hits] if event.payload.key? :cache_hits

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
