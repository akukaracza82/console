# frozen_string_literal: true

RSpec.describe Helium::Console::Registry do
  subject(:registry) { described_class.new(console) }

  let(:test_class) { Class.new }
  let(:object) { test_class.new }
  let(:console) { instance_double Helium::Console }
  let(:options) { { option_key: FFaker::Lorem.sentence } }

  before do
    option_key = options[:option_key]
    registry.add(test_class) { option_key }
  end

  it 'allows class-based write and read of the handlers' do
    stored_handler = registry.handler_for(object, **options)

    expect(stored_handler.()).to eq options[:option_key]
  end

  it 'finds the closest matching handler via object ancestry' do
    subclass = Class.new(test_class)
    stored_handler = registry.handler_for(subclass.new, **options)

    expect(stored_handler.()).to be options[:option_key]
  end
end
