# frozen_string_literal: true

module Rodash
  module NumericUtil
    class << self
      module Unit
        FEET = :ft
        METER = :m
      end

      def numeric?(value)
        !Float(value.to_s).nil?
      rescue StandardError
        false
      end

      def convert_unit(value, from_unit:, to_unit:)
        Measured::Length.new(value, from_unit).convert_to(to_unit).value.to_f
      end

      def convert_unit_sq(value, from_unit:, to_unit:)
        value = value.is_a?(String) ? BigDecimal(value) : value
        val = convert_unit(value, from_unit: from_unit, to_unit: to_unit)
        (val * val) / value
      end
    end
  end
end
