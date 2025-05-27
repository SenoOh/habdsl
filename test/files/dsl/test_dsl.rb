# frozen_string_literal: true

location(name: "house", label: "House", icon: "house") do
  table.each do |room|
    location(name: "#{room[:name]}", label: "#{room[:label]}", icon: "bedroom") do
      equipment(name: "#{room[:name]}_sensor", label: "#{room[:name]}_Sensor", icon: "siren") do
        point(name: "#{room[:name]}_temperature", label: "#{room[:name]} Temperature", type: "Number",
              icon: "temperature", tags: ["Temperature"])
      end
    end
  end
end
