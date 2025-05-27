# frozen_string_literal: true

location(name: "house", label: "House", icon: "house") do
  table.each do |_room|
    location(name: "room", label: "Room", icon: "room") do
      equipment(name: "sensor", label: "Sensor", icon: "sensor") do
        point(name: "temperature", label: "Temperature", type: "Number", icon: "temperature", tags: ["Temperature"])
      end
    end
  end
end
