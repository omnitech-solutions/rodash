# frozen_string_literal: true

module Rodash
  RSpec.describe ObjectUtil do
    describe '.to_classname' do
      context 'when given a class object that is not defined' do
        it 'returns nil' do
          expect(described_class.to_classname("Foo")).to be_nil
        end
      end
    end
  end
end

