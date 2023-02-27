# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module Rodash
  RSpec.describe HashUtil do
    let(:hash) { { data: { nestedKey: { id: "some-identifier", items: [4, 9, 7] } } } }

    describe 'dot notation' do
      let(:dotted_hash) do
        { "data.nestedKey.id" => "some-identifier",
          "data.nestedKey.items[0]" => 4,
          "data.nestedKey.items[1]" => 9,
          "data.nestedKey.items[2]" => 7 }
      end

      describe ".dot" do
        it "flattens deeply nested objects using dot notation" do
          expect(described_class.dot(hash, keep_arrays: false)).to eql(dotted_hash)
        end
      end

      describe ".dotted_keys" do
        it "flattens deeply nested objects to keys in dot notation" do
          expect(described_class.dotted_keys(hash, keep_arrays: false)).to eql(dotted_hash.keys)
        end
      end

      describe ".undot" do
        it "hydrates dotted hash to deeply nested object" do
          expect(described_class.undot(dotted_hash)).to eql(hash)
        end
      end

      describe '.pick' do
        it 'picks keys from hash' do
          paths = %w[data.nestedKey.id data.nestedKey.items[2] data.nestedKey.items[1]]
          expect(described_class.pick(hash, paths,
                                      keep_arrays: false)).to eql({ data: { nestedKey: { id: "some-identifier",
                                                                                         items: [9, 7] } } })
        end
      end

      describe '.get' do
        it 'picks keys from hash' do
          expect(described_class.get(hash, 'data.nestedKey.items[1]')).to be(9)
        end
      end

      describe '.set' do
        it 'sets key value pair at specified dotted path' do
          expect(described_class.set({}, 'data.nestedKey.items[1]',
                                     10)).to eql({ data: { nestedKey: { items: [nil, 10] } } })
        end
      end

      describe 'reject_blank_values' do
        let(:input) { { a: '', b: '  ', c: nil, d: '123', e: [], f: {} } }

        it 'removes blank values' do
          expect(described_class.reject_blank_values(input)).to eql({ d: "123", e: [], f: {} })
        end

        it 'does not deep remove blank values' do
          expect(described_class.reject_blank_values(input.merge(f: { g: '' }))).to eql({ d: "123", e: [],
                                                                                          f: { g: '' } })
        end
      end

      describe 'deep_reject_blank_values' do
        let(:input) { { a: '', b: '  ', c: nil, d: '123', e: [], f: { g: '' }, h: [1, nil, '', '    ', 3] } }

        it 'removes deep blank values' do
          expect(described_class.deep_reject_blank_values(input)).to eql({ d: "123", h: [1, 3] })
        end
      end
    end

    describe ".from_string" do
      let(:input) { JSON.dump(a: 1) }

      it "convert json string to hash" do
        expect(described_class.from_string(input)).to eql({ a: 1 })
      end

      it "handles hashes" do
        expect(described_class.from_string(a: 1)).to eql(a: 1)
      end
    end

    describe ".group_by" do
      let(:input) { [6.5, 4.12, 6.8, 5.4] }

      context 'with hash input' do
        let(:input) { [{ shared_key: 1, a: 1 }, { shared_key: 2, b: 2 }, { shared_key: 1, c: 3 }] }

        it 'handles key only' do
          expect(described_class.group_by(input,
                                          :shared_key)).to eql({
                                                                 1 => [{ shared_key: 1, a: 1 },
                                                                       { shared_key: 1,
                                                                         c: 3 }], 2 => [{ shared_key: 2, b: 2 }]
                                                               })
        end
      end

      it "groups elements" do
        expect(described_class.group_by(input, lambda { |val|
                                                 val.floor
                                               })).to eql({ 4 => [4.12], 5 => [5.4], 6 => [6.5, 6.8] })
      end
    end

    describe '.get_first_present' do
      let(:google_address) { '2253-20800 Westminster Hwy, Richmond, BC V6V 2W3, Canada' }
      let(:input) do
        { 'google_address' => '',
          'main_property' => { 'google_address' => '2253-20800 Westminster Hwy, Richmond, BC V6V 2W3, Canada' } }
      end
      let(:paths) { %w[google_address main_property.google_address] }

      subject(:present_val) { described_class.get_first_present(input, paths) }

      it 'returns first filled match' do
        expect(present_val).to eql(google_address)
      end
    end

    describe '.digest' do
      let(:input) { { key: 'some-value' } }

      subject(:digested_str) { described_class.digest(input) }
      it 'returns encoded digest string of input' do
        expect(digested_str).to eql('POWr8Qgq9OA+L8ejA4gkAG2kgNs=')
      end
    end

    describe ".to_str" do
      it "convert hash to json string" do
        # rubocop:disable Layout/LineLength
        expect(described_class.to_str(hash)).to eql("{\"data\":{\"nestedKey\":{\"id\":\"some-identifier\",\"items\":[4,9,7]}}}")
        # rubocop:enable Layout/LineLength
      end

      it "handles strings" do
        expect(described_class.to_str("{ a: 1 }")).to eql("{ a: 1 }")
      end
    end

    describe ".pretty" do
      it "returns correctly formatted string" do
        expect(described_class.pretty(hash)).to eql(%({
  "data": {
    "nestedKey": {
      "id": "some-identifier",
      "items": [
        4,
        9,
        7
      ]
    }
  }
}))
      end

      context 'with array' do
        let(:input) { [{ a: 1 }, b: 2] }

        it "returns correctly formatted string" do
          expect(described_class.pretty(input)).to eql(%([
  {
    "a": 1
  },
  {
    "b": 2
  }
]))
        end
      end
    end
  end
end
# rubocop:enable Metrics/ModuleLength
