# frozen_string_literal: true

require "spec_helper"
require "habdsl/json_parser"
require "habdsl/result_parser"

RSpec.describe Habdsl::JsonParser do
  let(:dsl_path) { File.expand_path("../../../test/files/dsl/test_dsl.rb", __dir__) }
  let(:input_code) { File.read(dsl_path) }

  describe ".parse" do
    context "with valid JSON file" do
      let(:json_path) { File.expand_path("../../../test/files/json/test.json", __dir__) }
      let(:json_code) { File.read(json_path) }

      it "returns a ParseResult" do
        result = described_class.parse(input_code: input_code, json_code: json_code)
        expect(result).to be_a(Habdsl::ResultParser)
        expect(result.table).to all(be_a(Hash))
        expect(result.dsl).not_to be_nil
      end
    end

    context "when JSON is not an array" do
      let(:json_path) { File.expand_path("../../../test/files/json/not_array.json", __dir__) }
      let(:json_code) { File.read(json_path) }

      it "raises ArgumentError" do
        expect do
          described_class.parse(input_code: input_code, json_code: json_code)
        end.to raise_error(ArgumentError, /Parsed JSON must be an Array of hashes/)
      end
    end

    context "when JSON array is empty" do
      let(:json_path) { File.expand_path("../../../test/files/json/empty_array.json", __dir__) }
      let(:json_code) { File.read(json_path) }

      it "raises ArgumentError" do
        expect do
          described_class.parse(input_code: input_code, json_code: json_code)
        end.to raise_error(ArgumentError, /JSON data array is empty/)
      end
    end

    context "when JSON is invalid format" do
      let(:json_code) { "invalid json string {" }

      it "raises JSON::ParserError" do
        expect do
          described_class.parse(input_code: input_code, json_code: json_code)
        end.to raise_error(JSON::ParserError)
      end
    end

    context "when DSL code is invalid" do
      let(:json_path) { File.expand_path("../../test/files/json/test.json", __dir__) }
      let(:json_code) { File.read(json_path) }
      let(:bad_input_code) { "this is invalid ruby code $$$" }

      it "raises error from DSL evaluation" do
        expect do
          described_class.parse(input_code: bad_input_code, json_code: json_code)
        end.to raise_error(StandardError)
      end
    end
  end
end
