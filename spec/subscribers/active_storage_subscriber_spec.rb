require 'spec_helper'

RSpec.describe Rails::Instrumentation::ActiveStorageSubscriber do
  let(:tracer) { OpenTracingTestTracer.build }

  before { allow(Rails::Instrumentation).to receive(:tracer).and_return(tracer) }

  describe 'Class Methods' do
    it 'responds to all event methods' do
      test_class_events(described_class)
    end
  end

  context 'when calling event method' do

    before { tracer.spans.clear }

    describe 'service_upload' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_upload.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_upload(event)

        expected_keys = %w[ key service checksum ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_streaming_download' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_streaming_download.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_streaming_download(event)

        expected_keys = %w[ key service ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_download' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_download.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_download(event)

        expected_keys = %w[ key service ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_delete' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_delete.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_delete(event)

        expected_keys = %w[ key service ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_delete_prefixed' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_delete_prefixed.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_delete_prefixed(event)

        expected_keys = %w[ key.prefix service ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_exist' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_exist.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_exist(event)

        expected_keys = %w[ key service exist ]
        check_span(expected_keys, tracer.spans.last)
      end
    end

    describe 'service_url' do
      let(:event) { ::ActiveSupport::Notifications::Event.new('service_url.active_storage', Time.now, Time.now, 0, {})}

      it 'adds tags' do
        described_class.service_url(event)

        expected_keys = %w[ key service url ]
        check_span(expected_keys, tracer.spans.last)
      end
    end
  end
end
