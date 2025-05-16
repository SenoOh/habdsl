# frozen_string_literal: true

require "#{Dir.pwd}/lib/habdsl"

input_code = <<~RUBY
  location(name: "house", label: "House", icon: "house") do
    equipment(name: "sensor", label: "Sensor", icon: "sensor") do
      point(name: "temperature", label: "Temperature", type: "Number",
            icon: "temperature", tags: ["Temperature"])
    end
  end
RUBY

begin
  output = Habdsl::DslParser.parse(input_code: input_code)
  puts "=== Generated table ==="
  p output.table
  puts ""
  puts "=== Generated DSL ==="
  puts output.dsl
rescue StandardError => e
  puts "エラー: #{e.message}"
end
