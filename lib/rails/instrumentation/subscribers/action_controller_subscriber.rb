module Rails
  module Instrumentation
    module ActionControllerSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'action_controller'.freeze

      EVENTS = %w[
        write_fragment
        read_fragment
        expire_fragment
        exist_fragment?
        write_page
        expire_page
        start_processing
        process_action
        send_file
        send_data
        redirect_to
        halted_callback
        unpermitted_parameters
      ].freeze

      # rubocop:disable Style/MutableConstant
      BASE_TAGS = { 'component' => 'ActionController' }
      # rubocop:enable Style/MutableConstant.

      class << self
        def write_fragment(event)
          tags = span_tags(
            'key.write' => event.payload[:key]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def read_fragment(event)
          tags = span_tags(
            'key.read' => event.payload[:key]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def expire_fragment(event)
          tags = span_tags(
            'key.expire' => event.payload[:key]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def exist_fragment?(event)
          tags = span_tags(
            'key.exist' => event.payload[:key]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def write_page(event)
          tags = span_tags(
            'path.write' => event.payload[:path]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def expire_page(event)
          tags = span_tags(
            'path.expire' => event.payload[:path]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def start_processing(event)
          tags = span_tags(
            'controller' => event.payload[:controller],
            'controller.action' => event.payload[:action],
            'request.params' => event.payload[:params],
            'request.format' => event.payload[:format],
            'http.method' => event.payload[:method],
            'http.url' => event.payload[:path]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def process_action(event)
          span_name = "#{event.payload[:controller]}.#{event.payload[:action]}"

          tags = span_tags(
            'controller' => event.payload[:controller],
            'controller.action' => event.payload[:action],
            'request.params' => event.payload[:params],
            'request.format' => event.payload[:format],
            'http.method' => event.payload[:method],
            'http.url' => event.payload[:path],
            'http.status_code' => event.payload[:status],
            'view.runtime.ms' => event.payload[:view_runtime],
            'db.runtime.ms' => event.payload[:db_runtime],
            'span.kind' => 'server'
          )

          # Only append these tags onto the active span created by the patched 'process_action'
          # Otherwise, create a new span for this notification as usual
          active_span = ::Rails::Instrumentation.tracer.active_span
          if active_span && active_span.operation_name == span_name
            tags.each do |key, value|
              ::Rails::Instrumentation.tracer.active_span.set_tag(key, value)
            end
          else
            Utils.trace_notification(event: event, tags: tags)
          end
        end

        def send_file(event)
          tags = span_tags(
            'path.send' => event.payload[:path]
          )

          # there may be additional keys in the payload. It might be worth
          # trying to tag them too

          Utils.trace_notification(event: event, tags: tags)
        end

        def send_data(event)
          # no defined keys, but user keys may be passed in. Might want to add
          # them at some point

          Utils.trace_notification(event: event, tags: BASE_TAGS)
        end

        def redirect_to(event)
          tags = span_tags(
            'http.status_code' => event.payload[:status],
            'redirect.url' => event.payload[:location]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def halted_callback(event)
          tags = span_tags(
            'filter' => event.payload[:filter]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def unpermitted_parameters(event)
          tags = span_tags(
            'unpermitted_keys' => event.payload[:keys]
          )

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
