# frozen_string_literal: true

module Rodash
  RSpec.describe UrlUtil do
    let(:url) { "http://html.joe.com/Jobs/123/249 Subert Place Feb29'27.pdf" }

    describe '.safe_escape' do
      it 'encodes url' do
        expect(described_class.safe_escape(url)).to eql("http://html.joe.com/Jobs/123/249%20Subert%20Place%20Feb29'27.pdf")
      end
    end

    describe '.error_from_http_status' do
      it 'returns appropriate http status message' do
        expect(described_class.error_from_http_status(400)).to eql("Bad Request")
      end

      context 'with invalid http status code' do
        it 'unknown http code message' do
          expect(described_class.error_from_http_status(-1)).to eql("Invalid HTTP Status Code")
        end
      end
    end
  end
end
