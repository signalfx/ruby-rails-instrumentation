require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActionControllerSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do
    before { tracer.spans.clear }

    describe 'write_fragment' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('write_fragment.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.write_fragment(event)

        expected_keys = %w[key.write]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'read_fragment' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('read_fragment.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.read_fragment(event)

        expected_keys = %w[key.read]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'expire_fragment' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('expire_fragment.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.expire_fragment(event)

        expected_keys = %w[key.expire]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'exist_fragment?' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('exist_fragment?.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.exist_fragment?(event)

        expected_keys = %w[key.exist]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'write_page' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('write_page.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.write_page(event)

        expected_keys = %w[path.write]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'expire_page' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('expire_page.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.expire_page(event)

        expected_keys = %w[path.expire]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'start_processing' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('start_processing.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.start_processing(event)

        expected_keys = %w[controller controller.action request.params request.format http.method http.url]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'process_action' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('process_action.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.process_action(event)

        expected_keys = %w[controller controller.action request.params request.format http.method http.url http.status_code view.runtime.ms db.runtime.ms]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'send_file' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('send_file.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.send_file(event)

        expected_keys = %w[path.send]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    # describe 'send_data' do
    #   let(:event) { ::ActiveSupport::Notifications::Event.new('send_data.action_controller', Time.now, Time.now, 0, {})}

    #   it 'adds tags' do
    #     described_class.send_data(event)

    #     check_span(expected_keys, tracer.spans.last)
    #   end
    # end

    describe 'redirect_to' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('redirect_to.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.redirect_to(event)

        expected_keys = %w[http.status_code redirect.url]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'halted_callback' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('halted_callback.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.halted_callback(event)

        expected_keys = %w[filter]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'unpermitted_parameters' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('unpermitted_parameters.action_controller', Time.now, Time.now, 0, {}) }

      it 'adds tags' do
        described_class.unpermitted_parameters(event)

        expected_keys = %w[unpermitted_keys]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
