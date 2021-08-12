# frozen_string_literal: true

RSpec.describe Helium::Console do
  subject(:console) { described_class.new(registry: registry) }

  let(:registry) { instance_spy(Helium::Console::Registry) }

  it 'has a version number' do
    expect(Helium::Console::VERSION).not_to be nil
  end

  describe '#register' do
    let(:test_class) { Class.new }
    let(:handler) { -> {} }

    it 'registers new class handler in the registry' do
      console.register(test_class, &handler)

      expect(registry).to have_received(:add) do |*received_args, &received_block|
        expect(received_args).to eq [test_class]
        expect(received_block).to be handler
      end
    end
  end

  describe '#format' do
    let(:object) { instance_double Object }

    context 'when given object has a matching formatter registered' do
      let(:result) { FFaker::Lorem.sentence }
      let(:handler) { instance_double Helium::Console::Registry::Element, call: result }

      before do
        allow(registry).to receive(:handler_for).with(object, instance_of(Hash)).and_return(handler)
      end

      it 'returns the result of formatting handler' do
        expect(console.format(object)).to eq result
      end
    end
  end
end
