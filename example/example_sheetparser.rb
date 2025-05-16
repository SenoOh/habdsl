# frozen_string_literal: true

require "#{Dir.pwd}/lib/habdsl"

input_code = File.read("#{Dir.pwd}/example/example_dsl.rb")

excel_path = "#{Dir.pwd}/example/example.xlsx"

begin
  output = Habdsl::SheetParser.parse(input_code: input_code, excel_path: excel_path)
  puts "=== Generated table ==="
  p output.table
  puts ""
  puts "=== Generated DSL ==="
  puts output.dsl
rescue StandardError => e
  puts "エラー: #{e.message}"
end
