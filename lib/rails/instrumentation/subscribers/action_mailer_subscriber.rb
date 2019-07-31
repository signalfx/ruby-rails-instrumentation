module Rails
  module Instrumentation
    module ActionMailerSubscriber
      include Subscriber

      EVENT_NAMESPACE = 'action_mailer'.freeze

      EVENTS = %w[
        receive
        deliver
        process
      ].freeze

      # rubocop:disable Style/MutableConstant
      BASE_TAGS = { 'component' => 'ActionMailer' }
      # rubocop:enable Style/MutableConstant.

      class << self
        def receive(event)
          tags = Utils.merged_tags(
            BASE_TAGS,
            'mailer' => event.payload[:mailer],
            'message.id' => event.payload[:message_id],
            'message.subject' => event.payload[:subject],
            'message.to' => event.payload[:to],
            'message.from' => event.payload[:from],
            'message.bcc' => event.payload[:bcc],
            'message.cc' => event.payload[:cc],
            'message.date' => event.payload[:date],
            'message.body' => event.payload[:mail]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def deliver(event)
          tags = Utils.merged_tags(
            BASE_TAGS,
            'mailer' => event.payload[:mailer],
            'message.id' => event.payload[:message_id],
            'message.subject' => event.payload[:subject],
            'message.to' => event.payload[:to],
            'message.from' => event.payload[:from],
            'message.bcc' => event.payload[:bcc],
            'message.cc' => event.payload[:cc],
            'message.date' => event.payload[:date],
            'message.body' => event.payload[:mail]
          )

          Utils.trace_notification(event: event, tags: tags)
        end

        def process(event)
          tags = Utils.merged_tags(
            BASE_TAGS,
            'mailer' => event.payload[:mailer],
            'action' => event.payload[:action],
            'args' => event.payload[:args]
          )

          Utils.trace_notification(event: event, tags: tags)
        end
      end
    end
  end
end
