module Rails
  module Instrumentation
    module Patch
      def self.patch_process_action
        ::ActionController::Instrumentation.class_eval do
          alias_method :process_action_original, :process_action

          def process_action(method_name, *args)
            # this naming scheme 'method.class' is how we ensure that the notification in the
            # subscriber is the same one
            name = "#{method_name}.#{self.class.name}"
            scope = ::Rails::Instrumentation.tracer.start_active_span(name)

            # skip adding tags here. Getting the complete set of information is easiest in the notification

            process_action_original(method_name, *args)
          rescue Error => error
            if scope
              scope.span.set_tag('error', true)
              scope.span.log_kv(key: 'message', value: error.message)
            end

            raise
          ensure
            scope.close
          end
        end
      end
    end
  end
end
