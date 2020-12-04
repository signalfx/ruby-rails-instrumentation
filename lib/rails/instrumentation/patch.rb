module Rails
  module Instrumentation
    module Patch
      def self.patch_process_action(klass: ::ActionController::Instrumentation)
        klass.class_eval do
          alias_method :process_action_original, :process_action

          def process_action(method_name, *args)
            # this naming scheme 'class.method' is how we ensure that the notification in the
            # subscriber is the same one
            name = "#{self.class.name}.#{method_name}"
            scope = ::Rails::Instrumentation.tracer.start_active_span(name)

            # skip adding tags here. Getting the complete set of information is
            # easiest in the notification
            process_action_original(method_name, *args)
          rescue Error => error
            if scope
              scope.span.record_exception(error)
            end

            raise
          ensure
            scope.close
          end
        end
      end

      def self.restore_process_action(klass: ::ActionController::Instrumentation)
        klass.class_eval do
          remove_method :process_action
          alias_method :process_action, :process_action_original
          remove_method :process_action_original
        end
      end
    end
  end
end
