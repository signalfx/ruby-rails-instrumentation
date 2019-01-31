require 'spec_helper'

RSpec.describe Rails::Instrumentation do
  let(:tracer) { OpenTracingTestTracer.build }

  describe 'Class Methods' do
    it { is_expected.to respond_to :instrument }
    it { is_expected.to respond_to :trace_notification }
  end
end
