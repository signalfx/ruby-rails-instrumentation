# require 'active_support'

module Rails
  module Instrumentation
    module ActionControllerSubscriber
      EVENT_NAMESPACE = 'action_controller'.freeze

      EVENTS = {
        'write_fragment' => {
          :key => 'key.write'
        },
        'read_fragment' => {
          :key => 'key.read'
        },
        'expire_fragment' => {
          :key => 'key.expire'
        },
        'exist_fragment?' => {
          :key => 'key.exist_fragment?'
        },
        'write_page' => {
          :path => 'path.write'
        },
        'expire_page' => {
          :path => 'path.expire'
        },
        'start_processing' => {
          :controller => 'controller',
          :action => 'controller.action',
          :params => 'request.params',
          :format => 'request.format',
          :method => 'http.method',
          :path => 'http.url'
        },
        'process_action' => {
          :controller => 'controller',
          :action => 'controller.action',
          :params => 'request.params',
          :format => 'request.format',
          :method => 'http.method',
          :path => 'http.url',
          :status => 'http.status_code',
          :view_runtime => 'view.runtime.ms',
          :db_runtime => 'db.runtime.ms'
        },
        'send_file' => {
          :path => 'path.file'
        },
        'send_data' => {},
        'redirect_to' => {
          :status => 'http.status_code',
          :location => 'redirect.url'
        },
        'halted_callback' => {
          :filter => 'filter'
        },
        'unpermitted_parameters' => {
          :keys => 'unpermitted_keys'
        },
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
