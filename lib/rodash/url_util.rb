# frozen_string_literal: true

module Rodash
  module UrlUtil
    class << self
      def safe_escape(url)
        Addressable::URI.escape(url).to_s
      end

      def error_from_http_status(http_status)
        Rack::Utils::HTTP_STATUS_CODES[http_status.to_i] || 'Invalid HTTP Status Code'
      end
    end
  end
end
