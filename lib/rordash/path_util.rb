# frozen_string_literal: true

module Rordash
  module PathUtil
    class << self
      def fixtures_path(path = '')
        Rails.root.join('spec', 'fixtures', path)
      end
    end
  end
end
