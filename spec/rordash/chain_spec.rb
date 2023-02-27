# frozen_string_literal: true

module Rordash
  RSpec.describe Chain do
    let(:instance) { described_class.new(value) }

    describe "#to_h" do
      let(:value) { JSON.dump(a: 1) }

      it "chains underlying hash util method" do
        expect(instance.to_h.value).to eql(a: 1)
      end
    end

    describe "#deep_compact" do
      let(:value) { { a: { b: { c: nil } }, d: 1, e: [], f: [1, 2, nil, 3, nil] } }

      it "chains underlying hash util method" do
        expect(
          instance.deep_compact.value
        ).to eql(e: [], f: [1, 2, 3])
      end
    end
  end
end
