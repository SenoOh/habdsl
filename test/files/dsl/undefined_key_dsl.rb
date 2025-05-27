# frozen_string_literal: true

location(name: "house", label: "House", icon: "house") do
  table.each do |room|
    location(name: "#{room[:icon]}", label: "#{room[:tags]}", icon: "room") do # :icon は存在しない
      equipment(name: "sensor", label: "Sensor", icon: "sensor") do
        point(name: "temperature", label: "Temperature", type: "Number", icon: "temperature", tags: ["Temperature"])
      end
    end
  end
end
