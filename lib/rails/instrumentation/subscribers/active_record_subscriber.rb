# require 'active_support'

module Rails
  module Instrumentation
    module ActiveRecordSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'active_record'.freeze

      EVENTS = %w[
        sql
        instantiation
      ].freeze

      class << self
        def sql(event)
          tags = {
            'db.statement' => event.payload[:sql],
            'name' => event.payload[:name],
            'connection_id' => event.payload[:connection_id],
            'binds' => event.payload[:binds],
            'cached' => event.payload[:cached]
          }

          Utils.trace_notification(event: event, tags: tags)
        end

        def instantiation(event)
          tags = {
            'record.count' => event.payload[:sql],
            'record.class' => event.payload[:class_name]
          }

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
