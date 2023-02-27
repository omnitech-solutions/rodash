# frozen_string_literal: true

module Rodash
  # rubocop:disable  RSpec/MessageSpies
  RSpec.describe DebugUtil do
    describe '.calculate_duration' do
      let(:tag) { nil }

      subject(:calculated_duration) { described_class.calculate_duration(tag: tag) { 'do-something' } }

      context 'without block' do
        it 'raises missing block error' do
          expect { described_class.calculate_duration }.to raise_error ArgumentError, 'Missing block'
        end
      end

      context 'with tag' do
        let(:tag) { 'some-tag' }

        it 'includes tag' do
          expect { calculated_duration }.to output(Regexp.new(/tag: `#{tag}` - total duration - /)).to_stdout
        end
      end

      it 'prints duration' do
        expect { calculated_duration }.to output(/tag: `default` - total duration - /).to_stdout
      end
    end

    describe '.wrap_stack_prof' do
      let(:tag) { nil }
      let(:out) { nil }

      subject(:profile_wrapper) { described_class.wrap_stack_prof(tag: tag, out: out) { 'do something' } }

      it 'wraps block inside stackprof runner' do
        expect(StackProf).to receive(:run).with(mode: :wall, out: 'tmp/stackprof.dump', raw: true, interval: 1000)

        profile_wrapper
      end

      it 'prints output file location' do
        expect(StackProf).to receive(:run).with(mode: :wall, out: 'tmp/stackprof.dump', raw: true, interval: 1000)

        expect { profile_wrapper }.to output(Regexp.new(%r{StackProf output file: tmp/stackprof.dump})).to_stdout
      end
    end
  end
  # rubocop:enable  RSpec/MessageSpies
end
