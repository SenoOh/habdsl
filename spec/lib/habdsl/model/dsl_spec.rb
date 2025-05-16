# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/habdsl/model/dsl"
require_relative "../../../../lib/habdsl/model/location"
require_relative "../../../../lib/habdsl/model/equipment"
require_relative "../../../../lib/habdsl/model/point"

RSpec.describe Habdsl::Model::Dsl do
  let(:dsl) { described_class.new }

  describe "#location" do
    it "creates a Location instance with given attributes" do
      loc = dsl.location(name: "kitchen", label: "Kitchen", icon: "kitchen")

      expect(loc).to be_a(Habdsl::Model::Location)
      expect(loc.name).to eq("kitchen")
      expect(loc.label).to eq("Kitchen")
      expect(loc.icon).to eq("kitchen")
    end

    it "evaluates the block inside the location instance" do
      loc = dsl.location(name: "kitchen", label: "Kitchen", icon: "kitchen") do
        equipment(name: "light", label: "Light", icon: "light") do
          point(name: "switch", label: "Light Switch", type: "Switch", icon: "switch", tags: ["Lighting"])
        end
      end

      expect(loc.equipments.size).to eq(1)
      eq = loc.equipments.first
      expect(eq.name).to eq("light")
      expect(eq.points.size).to eq(1)
      pt = eq.points.first
      expect(pt.name).to eq("switch")
      expect(pt.type).to eq("Switch")
    end

    it "evaluate location blocks within location instances" do
      loc = dsl.location(name: "house", label: "House", icon: "House") do
        location(name: "kitchen", label: "Kitchen", icon: "kitchen") do
          equipment(name: "light", label: "Light", icon: "light") do
            point(name: "switch", label: "Light Switch", type: "Switch", icon: "switch", tags: ["Lighting"])
          end
        end
      end

      expect(loc.sub_locations.size).to eq(1)
      sub_loc = loc.sub_locations.first
      expect(sub_loc.name).to eq("kitchen")
      expect(sub_loc.equipments.size).to eq(1)
      eq = sub_loc.equipments.first
      expect(eq.name).to eq("light")
      expect(eq.points.size).to eq(1)
      pt = eq.points.first
      expect(pt.name).to eq("switch")
      expect(pt.type).to eq("Switch")
    end
  end

  describe "#equipment" do
    it "creates an Equipment instance with given attributes" do
      eq = dsl.equipment(name: "heater", label: "Heater", icon: "heating")

      expect(eq).to be_a(Habdsl::Model::Equipment)
      expect(eq.name).to eq("heater")
    end

    it "evaluates the block inside the equipment instance" do
      eq = dsl.equipment(name: "fan", label: "Fan", icon: "fan") do
        point(name: "speed", label: "Fan Speed", type: "Number", icon: "speed", tags: ["HVAC"])
      end

      expect(eq.points.size).to eq(1)
      pt = eq.points.first
      expect(pt.name).to eq("speed")
    end

    it "evaluate equipment blocks within equipment instances" do
      eq = dsl.equipment(name: "fan", label: "Fan", icon: "fan") do
        equipment(name: "motor", label: "Motor", icon: "motor") do
          point(name: "speed", label: "Fan Speed", type: "Number", icon: "speed", tags: ["HVAC"])
        end
      end

      expect(eq.sub_equipments.size).to eq(1)
      sub_eq = eq.sub_equipments.first
      expect(sub_eq.name).to eq("motor")
      expect(sub_eq.points.size).to eq(1)
      pt = sub_eq.points.first
      expect(pt.name).to eq("speed")
    end
  end

  describe "#point" do
    it "creates a Point instance with given attributes" do
      pt = dsl.point(
        name: "temp",
        label: "Temperature",
        type: "Number",
        icon: "temperature",
        tags: ["Sensor"]
      )

      expect(pt).to be_a(Habdsl::Model::Point)
      expect(pt.name).to eq("temp")
      expect(pt.type).to eq("Number")
      expect(pt.tags).to eq(["Sensor"])
    end
  end
end
