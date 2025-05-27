# frozen_string_literal: true

require "spec_helper"
require "json"
require "habdsl/base_parser"

RSpec.describe Habdsl::BaseParser do
  let(:valid_table) do
    file_path = File.expand_path("../../../test/files/json/test.json", __dir__)
    JSON.parse(File.read(file_path), symbolize_names: true)
  end

  def load_dsl(filename)
    path = File.expand_path("../../../test/files/dsl/#{filename}", __dir__)
    File.read(path)
  end

  describe ".evaluate_dsl" do
    context "with a valid DSL file and table" do
      it "returns a ParseResult with generated DSL" do
        input_code = load_dsl("test_dsl.rb")
        result = described_class.evaluate_dsl(input_code: input_code, table: valid_table)

        expect(result).to be_a(Habdsl::ResultParser)
        expect(result.dsl).to include("Location")
        expect(result.dsl).to include("Equipment")
        expect(result.dsl).to include("Number")
      end
    end

    context "when DSL contains syntax error" do
      it "raises a DSLValidationError" do
        input_code = "location(name: 'x' do end" # missing )
        expect do
          described_class.evaluate_dsl(input_code: input_code, table: valid_table)
        end.to raise_error(Habdsl::BaseParser::DSLValidationError, /Syntax error/)
      end
    end

    context "when 'table' is not used in the DSL" do
      it "raises a DSLValidationError" do
        input_code = load_dsl("no_table_dsl.rb")

        expect do
          described_class.evaluate_dsl(input_code: input_code, table: valid_table)
        end.to raise_error(Habdsl::BaseParser::DSLValidationError, /'table' is not used/)
      end
    end

    context "when table keys are not used in generated output" do
      it "raises a DSLValidationError" do
        input_code = load_dsl("unused_keys_dsl.rb")

        expect do
          described_class.evaluate_dsl(input_code: input_code, table: valid_table)
        end.to raise_error(Habdsl::BaseParser::DSLValidationError, /table keys are not used/)
      end
    end

    context "when DSL tries to access undefined table key" do
      it "raises a NameError" do
        input_code = load_dsl("undefined_key_dsl.rb")

        expect do
          described_class.evaluate_dsl(input_code: input_code, table: valid_table)
        end.to raise_error(Habdsl::BaseParser::DSLValidationError, /Runtime error/)
      end
    end
  end
end
