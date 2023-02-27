# frozen_string_literal: true

module Rodash
  RSpec.describe PathUtil do
    describe '#fixtures_path' do
      context 'without arg' do
        it 'returns full fixture path' do
          fixtures_path = Rails.root.join('spec', 'fixtures')

          expect(described_class.fixtures_path).to eql(Pathname.new(fixtures_path))
        end
      end

      context 'with filename' do
        let(:filename) { 'some-file-name.png ' }

        it 'returns full fixture path' do
          fixtures_path = Rails.root.join('spec', 'fixtures')
          expect(described_class.fixtures_path(filename)).to eql(Pathname.new("#{fixtures_path}/#{filename}"))
        end
      end
    end
  end
end
