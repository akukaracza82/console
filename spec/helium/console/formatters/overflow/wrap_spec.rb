# frozen_string_literal: true

require 'helium/console/formatters/overflow/wrap'

RSpec.describe Helium::Console::Formatters::Overflow::Wrap do
  subject(:formatter) { described_class.new(max_width: max_width) }

  let(:formatted) { formatter.(text) }
  let(:text) { FFaker::Lorem.sentences(rand(4..10)).join("\n") }
  let(:max_width) { rand(8..12) }

  it 'splits the text into lines with appropriate length' do
    formatted.each_line do |line|
      expect(line.chomp.length).to be <= max_width
    end
  end

  context 'when original text ends with a new line character' do
    let(:text) { "#{super()}\n" }

    it 'is preserved' do
      expect(formatted).to end_with("\n")
    end
  end
end
