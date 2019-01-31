# require 'active_support'

module Rails
  module Instrumentation
    module ActionControllerSubscriber
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

        def subscribe(exclude_list: [])
          @subscribers = ::Rails::Instrumentation::Subscriber.subscribe(EVENTS, EVENT_NAMESPACE, [])
        end
      end
    end
  end
end
