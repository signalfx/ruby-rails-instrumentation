# require 'active_support'

module Rails
  module Instrumentation
    module ActionViewSubscriber
      EVENT_NAMESPACE = 'action_view'.freeze

      # This hash contains the events and the payload items to be tagged for
      # each event in this component.
      EVENTS = {
        'render_template' => {
          :identifier => 'template.identifier',
          :layout => 'template.layout'
        }.freeze,
        'render_partial' => {
          :identifier => 'partial.identifier',
        }.freeze,
        'render_collection' => {
          :identifier => 'collection.identifier',
          :count => 'collection.count',
          :cache_hits => 'collection.cache_hits'
        }.freeze
      }.freeze

      class << self

        def subscribe(exclude_list: [])
          @subscribers = []
          EVENTS.each do |event, payload_tags|
            event_name = "#{event}.#{EVENT_NAMESPACE}"
            @subscribers << ::Rails::Instrumentation::Subscriber.subscribe(event_name, payload_tags)
          end
        end
      end
    end
  end
end
