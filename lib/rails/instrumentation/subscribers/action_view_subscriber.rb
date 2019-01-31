# require 'active_support'

module Rails
  module Instrumentation
    module ActionViewSubscriber
      EVENT_NAMESPACE = 'action_view'.freeze

      EVENTS = %w[
        render_template
        render_partial
        render_collection
      ].freeze

      class << self

        def subscribe(exclude_list: [])
          @subscribers = ::Rails::Instrumentation::Subscriber.subscribe(EVENTS, EVENT_NAMESPACE, [])
        end
      end
    end
  end
end
