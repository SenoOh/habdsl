# frozen_string_literal: true

require "spec_helper"
require "json"
require "habdsl/dsl_parser"

RSpec.describe Habdsl::DslParser do
  def load_dsl(filename)
    path = File.expand_path("../../../test/files/dsl/#{filename}", __dir__)
    File.read(path)
  end

  describe ".parse" do
    context "with a valid DSL file" do
      it "returns a ResultParser with generated DSL" do
        input_code = load_dsl("no_table_dsl.rb")
        result = described_class.parse(input_code: input_code)

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
          described_class.parse(input_code: input_code)
        end.to raise_error(Habdsl::DslParser::DSLValidationError, /Syntax error/)
      end
    end
  end
end
