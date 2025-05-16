# frozen_string_literal: true

require "#{Dir.pwd}/lib/habdsl"

input_code = File.read("#{Dir.pwd}/example/example_dsl.rb")

json_code = File.read("#{Dir.pwd}/example/example.json")

begin
  output = Habdsl::JsonParser.parse(input_code: input_code, json_code: json_code)
  puts "=== Generated table ==="
  p output.table
  puts ""
  puts "=== Generated DSL ==="
  puts output.dsl
rescue StandardError => e
  puts "エラー: #{e.message}"
end
