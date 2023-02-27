# frozen_string_literal: true

module Rordash
  RSpec.describe FileUtil do
    let(:filename) { 'sample.csv' }
    let(:rel_path) { "files/#{filename}" }

    describe '.fixture_file_path' do
      it 'returns file contents' do
        actual = described_class.fixture_file_path(filename)

        expect(actual.exist?).to be_truthy
        expect(actual.to_s).to include("spec/fixtures/files/#{filename}")
      end
    end

    describe '#fixture_file_path_str' do
      it 'returns file contents' do
        expect(described_class.fixture_file_path_str(filename)).to include("spec/fixtures/files/#{filename}")
      end
    end

    describe '#read_fixture_file' do
      it 'returns file contents' do
        expect(described_class.read_fixture_file(rel_path)).to include("Gemma Jones,Sept 1 2018,silver")
      end
    end

    describe '#read_fixture_file_as_hash' do
      let(:rel_path) { 'files/sample.json' }

      it 'returns file contents' do
        expect(described_class.read_fixture_file_as_hash(rel_path)).to eql([
                                                                             {
                                                                               color: "red",
                                                                               value: "#f00"
                                                                             }
                                                                           ])
      end
    end

    describe '.content_type_from_filename' do
      let(:filename) { 'sample.pdf' }

      subject(:content_type) { described_class.content_type_from_filename(filename) }

      it 'returns content type' do
        expect(content_type).to eql('application/pdf')
      end
    end

    describe '.mime_type_from_filename' do
      let(:filename) { 'sample.pdf' }

      subject(:mime_type) { described_class.mime_type_from_filename(filename) }

      it 'returns content type' do
        expect(mime_type).to eql(MIME::Types['application/pdf'].first)
      end
    end

    describe '.file_url_for' do
      let(:filename) { 'sample.pdf' }

      subject(:file_url) { described_class.file_url_for(filename) }

      it 'returns url with filename' do
        expect(file_url).to match(RegexUtil::TYPE[:uri])
        expect(file_url).to include(filename)
      end
    end

    context 'with content types' do
      let(:content_types) do
        [
          { content_type: 'image/png', extension: 'png' },
          { content_type: 'text/csv', extension: 'csv' },
          { content_type: 'application/msword', extension: 'doc' },
          { content_type: 'text/html', extension: 'html' },
          { content_type: 'application/zip', extension: 'zip' },
          { content_type: 'image/bmp', extension: 'bmp' },
          { content_type: 'application/vnd.ms-publisher', extension: 'pub' },
          { content_type: 'image/jp2', extension: 'jp2' },
          { content_type: 'video/mp4', extension: 'mp4' },
          { content_type: 'application/pdf', extension: 'pdf' },
          { content_type: 'image/svg+xml', extension: 'svg' },
          { content_type: 'application/octet-stream', extension: 'bin' },
          { content_type: 'image/webp', extension: 'webp' },
          { content_type: 'image/gif', extension: 'gif' },
          { content_type: 'text/plain', extension: 'txt' },
          { content_type: 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            extension: 'pptx' },
          { content_type: 'image/heic', extension: 'heic' },
          { content_type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            extension: 'docx' },
          { content_type: 'image/jpeg', extension: 'jpeg' },
          { content_type: 'image/tiff', extension: 'tiff' }
        ]
      end

      describe '.filename_with_ext_from' do
        let(:filename_without_extension) { 'filename' }

        it 'returns the correct extension' do
          content_types.each do |content_type:, extension:|
            actual = described_class.filename_with_ext_from(filename: filename_without_extension,
                                                            content_type: content_type)
            expect(actual).to eql("#{filename_without_extension}.#{extension}")
          end
        end
      end

      describe '.content_type_to_extension' do
        it 'returns the correct extension' do
          content_types.each do |content_type:, extension:|
            actual = described_class.content_type_to_extension(content_type)
            expect(actual).to eql(extension)
          end
        end
      end
    end
  end
end
