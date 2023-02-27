# frozen_string_literal: true

module Rordash
  RSpec.describe RegexUtil do
    describe '.match?' do
      subject(:matched) { described_class.match?(type, value) }

      let(:value) { nil }
      let(:type) { nil }

      describe ':email' do
        let(:type) { :email }

        context 'with valid email' do
          let(:value) { 'email@domain.com' }

          it 'returns true' do
            expect(matched).to be_truthy
          end
        end

        context 'with invalid email' do
          let(:value) { 'emaild.g' }

          it 'returns false' do
            expect(matched).to be_falsey
          end
        end
      end

      context 'with a URI' do
        it 'returns true for a valid URI' do
          expect(described_class.match?(:uri, 'https://www.example.com')).to be_truthy
        end

        it 'returns false for an invalid URI' do
          expect(described_class.match?(:uri, 'not a uri')).to be_falsey
        end
      end

      context 'with a postal code' do
        it 'returns true for a valid postal code' do
          expect(described_class.match?(:postal_code, 'V5K 0A1')).to be_truthy
        end

        it 'returns false for an invalid postal code' do
          expect(described_class.match?(:postal_code, 'not a postal code')).to be_falsey
        end
      end

      context 'with a dotted index' do
        it 'returns true for a valid dotted index' do
          expect(described_class.match?(:dotted_index, 'person.address[0]')).to be_truthy
        end

        it 'returns false for an invalid dotted index' do
          expect(described_class.match?(:dotted_index, 'not a dotted index')).to be_falsey
        end
      end
    end

    describe '#match' do
      it 'returns the matched value for a successful match' do
        expect(described_class.match(:uri, 'https://www.example.com').to_s).to eq('https://www.example.com')
      end

      it 'returns nil for an unsuccessful match' do
        expect(described_class.match(:uri, 'not a uri')).to be_nil
      end
    end

    describe '#replace' do
      it 'replaces the matched value with the replacement string' do
        expect(described_class.replace(:postal_code, 'V5K 0A1', 'REDACTED')).to eq('REDACTED')
      end

      it 'returns the original value if the regular expression does not match' do
        expect(described_class.replace(:postal_code, 'not a postal code', 'REDACTED')).to eq('not a postal code')
      end

      it 'returns the original value if the value is not a string' do
        expect(described_class.replace(:postal_code, 123, 'REDACTED')).to eq(123)
      end
    end
  end
end
