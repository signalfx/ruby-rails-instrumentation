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

      class << self
        def write_fragment(event)
          tags = {
            'key.write' => event.payload[:key]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def read_fragment(event)
          tags = {
            'key.read' => event.payload[:key]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def expire_fragment(event)
          tags = {
            'key.expire' => event.payload[:key]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def exist_fragment?(event)
          tags = {
            'key.exist' => event.payload[:key]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def write_page(event)
          tags = {
            'path.write' => event.payload[:path]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def expire_page(event)
          tags = {
            'path.expire' => event.payload[:path]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def start_processing(event)
          tags = {
            'controller' => event.payload[:controller],
            'controller.action' => event.payload[:action],
            'request.params' => event.payload[:params],
            'request.format' => event.payload[:format],
            'http.method' => event.payload[:method],
            'http.url' => event.payload[:path]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def process_action(event)
          tags = {
            'controller' => event.payload[:controller],
            'controller.action' => event.payload[:action],
            'request.params' => event.payload[:params],
            'request.format' => event.payload[:format],
            'http.method' => event.payload[:method],
            'http.url' => event.payload[:path],
            'http.status_code' => event.payload[:status],
            'view.runtime.ms' => event.payload[:view_runtime],
            'db.runtime.ms' => event.payload[:db_runtime]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def send_file(event)
          tags = {
            'path.send' => event.payload[:path]
          }

          # there may be additional keys in the payload. It might be worth
          # trying to tag them too

          Utils.trace_notification(event: event, tags: tags)
        end

        def send_data(event)
          # no defined keys, but user keys may be passed in. Might want to add
          # them at some point

          Utils.trace_notification(event: event, tags: tags)
        end

        def redirect_to(event)
          tags = {
            'http.status_code' => event.payload[:status],
            'redirect.url' => event.payload[:location]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def halted_callback(event)
          tags = {
            'filter' => event.payload[:filter]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def unpermitted_parameters(event)
          tags = {
            'unpermitted_keys' => event.payload[:keys]
          }

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
