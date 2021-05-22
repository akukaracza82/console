require 'helium/console/formatters/overflow/wrap'

RSpec.describe Helium::Console::Formatters::Overflow::Wrap do
  let(:text) { FFaker::Lorem.sentences(rand(4..10)).join($/) }
  let(:max_width) { rand(8..12) }

  subject(:formatter) { described_class.new(max_width: max_width) }
  subject(:formatted) { formatter.call(text) }


  it "splits the text into lines with appropriate length" do
    formatted.each_line do |line|
      expect(line.chomp.length).to be <= max_width
    end
  end

  context "when original text ends with a new line character" do
    let(:text) { super() + $/ }

    it "is preserved" do
      expect(formatted).to end_with($/)
    end
  end
end
