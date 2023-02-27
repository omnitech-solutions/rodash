# frozen_string_literal: true

module Rodash
  module RegexUtil
    EMAIL_MATCH = URI::MailTo::EMAIL_REGEXP
    POSTAL_CODE_MATCH = /[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d/.freeze
    DOTTED_INDEX_MATCH = /\w+\[\d+\]/.freeze
    URI_MATCH = URI::DEFAULT_PARSER.make_regexp.freeze

    TYPE = {
      email: EMAIL_MATCH,
      uri: URI_MATCH,
      postal_code: POSTAL_CODE_MATCH,
      dotted_index: DOTTED_INDEX_MATCH
    }.freeze

    class << self
      def match?(type, value)
        TYPE[type].match?(value)
      end

      def match(type, value)
        TYPE[type].match(value)
      end

      def replace(type, value, replacement)
        return value unless value.is_a?(String)

        regex = TYPE[type]
        return value if regex.nil?

        value.sub(regex, replacement)
      end
    end
  end
end
