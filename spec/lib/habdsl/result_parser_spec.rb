# frozen_string_literal: true

require "spec_helper"
require "habdsl/result_parser"
require "json"

RSpec.describe Habdsl::ResultParser do
  let(:json_path) { File.expand_path("../../../test/files/json/test.json", __dir__) }
  let(:json) { File.read(json_path) }
  let(:table_data) { JSON.parse(json, symbolize_names: true) }

  let(:dsl_path) { File.expand_path("../../../test/files/dsl/test_dsl.rb", __dir__) }
  let(:dsl_data) { File.read(dsl_path) }

  subject(:parse_result) { described_class.new(table: table_data, dsl: dsl_data) }

  describe "#initialize" do
    it "sets the table" do
      expect(parse_result.table).to eq(table_data)
    end

    it "sets the dsl" do
      expect(parse_result.dsl).to eq(dsl_data)
    end
  end
end
