# frozen_string_literal: true

require "#{Dir.pwd}/lib/habdsl"

input_code = <<~RUBY
  location(name: "house", label: "House", icon: "house") do
    location(name: "livingroom", label: "Living Room", icon: "bedroom") do
      equipment(name: "sensor", label: "Sensor", icon: "siren") do
        point(name: "temperature", label: "Temperature", type: "Number",
              icon: "temperature", tags: ["Temperature"], channel: "mqtt:topic:mqttbroker:temperature")
      end
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
