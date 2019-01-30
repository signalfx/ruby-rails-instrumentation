module Rails
  module Instrumentation
    module ActionController
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

        def subscribe
          EVENTS.each do |event_name|
            ::ActiveSupport::Notifications.subscribe("#{event_name}.#{EVENT_NAMESPACE}") do |*args|
              ::Rails::Instrumentation.trace_event(*args)
            end
          end
        end
      end
    end
  end
end
