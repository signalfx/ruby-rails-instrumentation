require 'spec_helper'
require 'action_controller'

RSpec.describe ::Rails::Instrumentation::Patch do
  describe 'Class Methods' do
    it { is_expected.to respond_to :patch_process_action }
  end

  describe 'Patched Controller class' do
    let(:tracer) { OpenTracingTestTracer.build }
    let(:test_controller) { Test.new }

    before do
      allow(::Rails::Instrumentation).to receive(:tracer).and_return(tracer)
      class Test < ::ActionController::Base; end
      described_class.patch_process_action(klass: Test)
    end

    after { described_class.restore_process_action(klass: Test) }

    it 'creates an active span' do
      allow(test_controller).to receive(:process_action_original)
      test_controller.send(:process_action, 'test_action')

      expect(tracer.spans.count).to eq 1
    end
  end
end
