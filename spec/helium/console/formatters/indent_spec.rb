# frozen_string_literal: true

RSpec.describe Helium::Console::Formatters::Indent do
  subject(:formatter) { described_class.new(indent) }

  let(:formatted) { formatter.(text) }
  let(:text) { FFaker::Lorem.sentences(rand(4..10)).join("\n") }
  let(:indent) { rand(1..3) * 2 }

  it 'pads each line with given indent' do
    formatted.lines.zip(text.lines) do |formatted_line, original_line|
      expect(formatted_line.chars.first(indent).uniq).to eq [' ']
      expect(formatted_line[indent..-1]).to eq original_line
    end
  end
end
