# frozen_string_literal: true

module Rordash
  module FileUtil
    FILE_EXTENSION_MATCH = /^.*\.\S+\w$/.freeze
    CONTENT_TYPE_TO_EXT_MATCH = %r{/(.*)$}.freeze
    UNSUPPORTED_CONTENT_TYPE_MAP = {
      'application/vnd.ms-publisher' => 'pub'
    }.freeze

    class << self
      def filename_with_ext_from(filename:, content_type:)
        filename = filename.to_s.strip
        return filename if filename.blank?
        return filename if filename_has_extension?(filename)
        return filename if content_type.blank?

        ext = content_type_to_extension(content_type)
        return filename if ext.blank?

        "#{filename}.#{ext}"
      end

      def content_type_to_extension(content_type)
        return content_type if content_type.blank?

        ext = mime_type_for_content_type(content_type)&.preferred_extension
        ext = UNSUPPORTED_CONTENT_TYPE_MAP[content_type] if ext.blank?
        ext = content_type.match(CONTENT_TYPE_TO_EXT_MATCH).to_a.last if ext.blank?
        ext
      end

      def fixture_file_path(filename)
        rel_path = PathUtil.fixtures_path('files')
        path = rel_path.join(filename)

        if path.exist?
          path
        else
          msg = "the directory '%s' does not contain a file named '%s'"
          raise ArgumentError, format(msg, rel_path, filename)
        end
      end

      def fixture_file_path_str(filename)
        fixture_file_path(filename).to_s
      end

      def read_fixture_file(rel_path)
        File.read(PathUtil.fixtures_path(rel_path))
      end

      def open_fixture_file(filename)
        pathname = Utils::FileUtil.fixture_file_path(filename)
        return nil unless pathname.exist?

        ::File.open(pathname.to_s)
      end

      def read_fixture_file_as_hash(rel_path)
        HashUtil.from_string(read_fixture_file(rel_path))
      end

      def create_file_blob(filename:, content_type: nil, metadata: nil)
        content_type = content_type.present? ? content_type : content_type_from_filename(filename) || Mime[:jpg]

        raise StandardError, "ActiveStorage must be installed" unless defined? ActiveStorage::Blob

        ActiveStorage::Blob.create_after_upload! io: ::File.open(fixture_file_path(filename).to_s), filename: filename,
                                                 content_type: content_type, metadata: metadata
      end

      def file_url_for(filename)
        Addressable::URI.parse(Faker::Internet.url)&.join(filename).to_s
      end

      def content_type_from_filename(filename)
        mime_type = mime_type_from_filename(filename)
        mime_type&.content_type
      end

      def mime_type_from_filename(filename)
        MIME::Types.type_for(filename).first
      end

      def mime_type_for_content_type(content_type)
        MIME::Types[content_type].first
      end

      def filename_has_extension?(filename)
        filename.to_s.match?(FILE_EXTENSION_MATCH)
      end
    end
  end
end
