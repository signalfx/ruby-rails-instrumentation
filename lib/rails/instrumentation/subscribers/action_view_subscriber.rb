module Rails
  module Instrumentation
    module ActionViewSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'action_view'.freeze

      EVENTS = %w[
        render_template
        render_partial
        render_collection
      ].freeze

      class << self
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
