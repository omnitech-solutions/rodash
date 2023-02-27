# frozen_string_literal: true

module Rordash
  RSpec.describe NumericUtil do
    describe '.numeric?' do
      let(:value) { '12345' }

      subject(:is_numeric) { described_class.numeric?(value) }

      it 'returns true' do
        expect(is_numeric).to be_truthy
      end

      context 'with value with non numeric values' do
        let(:value) { '12A345' }

        it 'returns false' do
          expect(is_numeric).to be_falsey
        end
      end

      context 'with blank value' do
        let(:value) { '' }

        it 'returns false' do
          expect(is_numeric).to be_falsey
        end
      end

      context 'with whitespace' do
        let(:value) { '  1' }

        it 'returns false' do
          expect(is_numeric).to be_truthy
        end
      end
    end

    describe '.convert_unit' do
      let(:from_unit) { :m }
      let(:to_unit) { :ft }
      let(:value) { 10 }

      subject(:converted_unit) { described_class.convert_unit(value, from_unit: from_unit, to_unit: to_unit) }

      it 'calculates amount correctly' do
        expect(converted_unit.round(4)).to be(32.8084)
      end
    end

    describe '.convert_unit_sq' do
      let(:from_unit) { :m }
      let(:to_unit) { :ft }
      let(:value) { 25 }

      subject(:sq_unit) { described_class.convert_unit_sq(value, from_unit: from_unit, to_unit: to_unit) }

      it 'calculates amount correctly' do
        expect(sq_unit.round(3)).to be(269.098)
      end
    end
  end
end
