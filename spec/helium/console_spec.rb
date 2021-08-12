# frozen_string_literal: true

RSpec.describe Helium::Console do
  subject { described_class.new(registry: registry) }

  let(:registry) { instance_spy(Helium::Console::Registry) }

  it 'has a version number' do
    expect(Helium::Console::VERSION).not_to be nil
  end

  describe '#register' do
    let(:test_class) { Class.new }
    let(:handler) { -> {} }

    it 'registers new class handler in the registry' do
      subject.register(test_class, &handler)

      expect(registry).to have_received(:add) do |*received_args, &received_block|
        expect(received_args).to eq [test_class]
        expect(received_block).to be handler
      end
    end
  end

  describe '#format' do
    let(:object) { double 'Object to format' }

    context 'when given object has a matching formatter registered' do
      let(:result) { FFaker::Lorem.sentence }
      let(:handler) { double 'object format handler', call: result }

      before do
        allow(registry).to receive(:handler_for).with(object, instance_of(Hash)).and_return(handler)
      end

      it 'returns the result of formatting handler' do
        expect(subject.format(object)).to eq result
      end
    end

    context 'when given object has no matching formatter registered' do
      let(:object) { double 'Object to format', inspect: double("Object's inspect") }
      let(:formatted_object_inspect) { double "Formatted object's inspect" }

      before do
        allow(registry).to receive(:handler_for).with(object, instance_of(Hash)).and_return nil
        allow(subject).to receive(:format).and_call_original
        allow(subject).to receive(:format).with(object.inspect, **subject.default_options)
          .and_return formatted_object_inspect
      end

      it 'formats its inspect string instead' do
        expect(subject.format(object)).to eq formatted_object_inspect
      end
    end
  end
end
