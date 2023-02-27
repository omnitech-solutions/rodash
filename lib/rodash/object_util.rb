# frozen_string_literal: true

module Rodash
  module ObjectUtil
    class << self
      def to_class(classname)
        classname.constantize if classname.is_a?(String)
        classname
      end

      def to_classname(klass)
        return klass.name if Object.const_defined?(klass)

        nil
      end
    end
  end
end
