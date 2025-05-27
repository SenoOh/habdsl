# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/habdsl/model/point"

RSpec.describe Habdsl::Model::Point do
  describe "#initialize" do
    it "creates a valid Point with all parameters" do
      point = described_class.new(
        name: "tempSensor",
        label: "Temperature",
        type: "Number",
        icon: "temp",
        tags: ["Sensor"],
        parent: "Room"
      )

      expect(point.name).to eq("tempSensor")
      expect(point.label).to eq("Temperature")
      expect(point.type).to eq("Number")
      expect(point.icon).to eq("temp")
      expect(point.tags).to eq(["Sensor"])
      expect(point.parent).to eq("Room")
    end

    it "raises error if name is missing" do
      expect do
        described_class.new(label: "Temperature", type: "Number", icon: "temp", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /missing keyword: :name/)
    end

    it "raises error if label is missing" do
      expect do
        described_class.new(name: "temp", type: "Number", icon: "temp", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /missing keyword: :label/)
    end

    it "raises error if type is missing" do
      expect do
        described_class.new(name: "temp", label: "Temperature", icon: "temp", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /missing keyword: :type/)
    end

    it "raises error if icon is missing" do
      expect do
        described_class.new(name: "temp", label: "Temperature", type: "Number", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /missing keyword: :icon/)
    end

    it "raises error if tags is missing" do
      expect do
        described_class.new(name: "temp", label: "Temperature", type: "Number", icon: "temp")
      end.to raise_error(ArgumentError, /missing keyword: :tags/)
    end

    it "raises error if name is invalid" do
      expect do
        described_class.new(name: "123invalid", label: "Temp", type: "Number", icon: "temp", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /name is invalid/)
    end

    it "raises error if type is invalid" do
      expect do
        described_class.new(name: "temp", label: "Temp", type: "123type", icon: "temp", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /type is invalid/)
    end

    it "raises error if icon is invalid" do
      expect do
        described_class.new(name: "temp", label: "Temp", type: "Number", icon: "$$$", tags: ["Sensor"])
      end.to raise_error(ArgumentError, /icon is invalid/)
    end
  end

  describe "#to_s" do
    it "returns string with minimal attributes" do
      point = described_class.new(
        name: "basic",
        label: "Label",
        type: "String",
        icon: "default",
        tags: []
      )
      expected = 'String basic "Label" <default> []' + "\n"
      expect(point.to_s).to eq(expected)
    end

    it "includes icon and parent in to_s" do
      point = described_class.new(
        name: "temp",
        label: "Temperature",
        type: "Number",
        icon: "temp",
        tags: ["Sensor"],
        parent: "Room"
      )
      expected = 'Number temp "Temperature" <temp> (Room) ["Sensor"]' + "\n"
      expect(point.to_s).to eq(expected)
    end
  end

  describe "structure constraints" do
    let(:point) do
      described_class.new(
        name: "temp",
        label: "Temperature",
        type: "Number",
        icon: "temp",
        tags: []
      )
    end

    it "raises error when calling #location" do
      expect { point.location }.to raise_error(/location cannot be nested/)
    end

    it "raises error when calling #equipment" do
      expect { point.equipment }.to raise_error(/equipment cannot be nested/)
    end
  end
end
