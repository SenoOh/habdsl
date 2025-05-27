# frozen_string_literal: true

require "roo"
require_relative "base_parser"

module Habdsl
  # Parser for Spreadsheet input
  class SheetParser
    def self.parse(input_code:, excel_path:)
      raise ArgumentError, "Excel file does not exist: #{excel_path}" unless File.exist?(excel_path)

      xlsx = Roo::Spreadsheet.open(excel_path.to_s)
      sheet = xlsx.sheet(0)
      headers = sheet.row(1).map(&:to_sym)

      table = []
      (2..sheet.last_row).each do |row_num|
        row = sheet.row(row_num)
        data = Hash[headers.zip(row)]
        table << data
      end

      raise ArgumentError, "No data rows found in sheet" if table.empty?

      BaseParser.evaluate_dsl(input_code: input_code, table: table)
    end
  end
end
