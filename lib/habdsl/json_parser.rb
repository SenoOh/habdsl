# frozen_string_literal: true

require "json"
require_relative "base_parser"

module Habdsl
  # Parser for JSON input
  class JsonParser
    def self.parse(input_code:, json_code:)
      table = JSON.parse(json_code, symbolize_names: true)

      raise ArgumentError, "Parsed JSON must be an Array of hashes" unless table.is_a?(Array)

      raise ArgumentError, "JSON data array is empty" if table.empty?

      BaseParser.evaluate_dsl(input_code: input_code, table: table)
    end
  end
end
