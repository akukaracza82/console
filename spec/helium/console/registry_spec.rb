# frozen_string_literal: true

RSpec.describe Helium::Console::Registry do
  let(:test_class) { Class.new }
  let(:object) { test_class.new }

  let(:handler) { spy 'Test class handler', call: handler_result }
  let(:handler_result) { double 'Handler result' }

  before do
    handler = self.handler
    subject.add(test_class) { |*args| handler.(*args) }
  end

  it 'allows class-based write and read of the handlers' do
    stored_handler = subject.handler_for(object)
    some_args = Array.new(2) { double }

    expect(stored_handler.(*some_args)).to be handler_result
    expect(handler).to have_received(:call).with(*some_args)
  end

  it 'finds the closest matching handler via object ancestry' do
    subclass = Class.new(test_class)
    stored_handler = subject.handler_for(subclass.new)
    some_args = Array.new(2) { double }

    expect(stored_handler.(*some_args)).to be handler_result
    expect(handler).to have_received(:call).with(*some_args)
  end
end
