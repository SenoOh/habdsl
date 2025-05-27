# frozen_string_literal: true

require "spec_helper"
require "habdsl/sheet_parser"
require "habdsl/result_parser"

RSpec.describe Habdsl::SheetParser do
  describe ".parse" do
    let(:dsl_path) { File.expand_path("../../../test/files/dsl/test_dsl.rb", __dir__) }
    let(:input_code) { File.read(dsl_path) }

    context "with valid input" do
      let(:excel_path) { File.expand_path("../../../test/files/excel/test.xlsx", __dir__) }

      it "returns a ParseResult" do
        result = described_class.parse(input_code: input_code, excel_path: excel_path)
        expect(result).to be_a(Habdsl::ResultParser)
        expect(result.table).to all(be_a(Hash))
        expect(result.dsl).not_to be_nil
      end
    end

    context "when the Excel file does not exist" do
      let(:invalid_path) { File.expand_path("../../../test/files/excel/missing.xlsx", __dir__) }

      it "raises an ArgumentError" do
        expect do
          described_class.parse(input_code: input_code, excel_path: invalid_path)
        end.to raise_error(ArgumentError, /Excel file does not exist/)
      end
    end

    context "when the Excel has no data rows" do
      let(:empty_data_path) { File.expand_path("../../../test/files/excel/empty_data.xlsx", __dir__) }

      it "raises an ArgumentError for no data rows" do
        expect do
          described_class.parse(input_code: input_code, excel_path: empty_data_path)
        end.to raise_error(ArgumentError, /No data rows found in sheet/)
      end
    end

    context "when DSL code is invalid" do
      let(:excel_path) { File.expand_path("../../../test/files/excel/test.xlsx", __dir__) }
      let(:bad_input_code) { "this is invalid ruby code $$$" }

      it "raises an error from DSL evaluation" do
        expect do
          described_class.parse(input_code: bad_input_code, excel_path: excel_path)
        end.to raise_error(StandardError)
      end
    end
  end
end
