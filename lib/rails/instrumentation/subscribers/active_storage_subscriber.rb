
module Rails
  module Instrumentation
    module ActiveStorageSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'active_storage'.freeze

      EVENTS = %w[
        service_upload
        service_streaming_download
        service_download
        service_delete
        service_delete_prefixed
        service_exist
        service_url
      ].freeze

      class << self
        def service_upload(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service],
            'checksum' => event.payload[:checksum]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_streaming_download(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_download(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_delete(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_delete_prefixed(event)
          tags = {
            'key.prefix' => event.payload[:prefix],
            'service' => event.payload[:service]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_exist(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service],
            'exist' => event.payload[:exist]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def service_url(event)
          tags = {
            'key' => event.payload[:key],
            'service' => event.payload[:service],
            'url' => event.payload[:url] # generated url, not accessed url
          }

          Utils.trace_notification(event: event, tags: tags)
        end

      end
    end
  end
end
