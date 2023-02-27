# frozen_string_literal: true

module Rodash
  module PathUtil
    class << self
      def fixtures_path(path = '')
        Rails.root.join('spec', 'fixtures', path)
      end
    end
  end
end
