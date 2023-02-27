# frozen_string_literal: true

module Rordash
  module DebugUtil
    class << self
      # rubocop:disable Metrics/AbcSize
      def calculate_duration(tag: nil, &block)
        tag = :default unless tag.present?
        started_at = Time.now.to_f
        raise ArgumentError, 'Missing block' unless block

        yield
        ended_at = Time.now.to_f

        duration_with_ms = ended_at - started_at
        duration_in_seconds = duration_with_ms.floor

        seconds = format("%.1f", duration_with_ms)
        minutes = (duration_in_seconds / 60) % 60
        hours = duration_in_seconds / (60 * 60)
        puts "tag: `#{tag}` - total duration - #{hours} hours #{minutes} minutes and #{seconds} seconds".light_blue
      end
      # rubocop:enable Metrics/AbcSize

      def wrap_stack_prof(tag: nil, out: nil, &block)
        tag = :default unless tag.present?
        out = 'tmp/stackprof.dump' unless out.present?

        calculate_duration(tag: tag) do
          StackProf.run(mode: :wall, out: out, raw: true, interval: 1000, &block)
          puts "\n\nStackProf output file: #{out}".yellow
        end
      end
    end
  end
end

