# frozen_string_literal: true

RSpec.describe Rordash do
  it "has a version number" do
    expect(Rordash::VERSION).not_to be_nil
  end

  describe '.chain' do
    describe "#to_h" do
      let(:value) { JSON.dump(a: 1) }

      it "chains underlying hash util method" do
        expect(described_class.chain(JSON.dump(a: 1)).to_h.value).to eql(a: 1)
      end
    end
  end
end
