# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/habdsl/model/equipment"
require_relative "../../../../lib/habdsl/model/point"

RSpec.describe Habdsl::Model::Equipment do
  describe "#initialize" do
    it "creates a valid Equipment with all parameters" do
      equipment = described_class.new(name: "light", label: "Lighting", icon: "light", parent: "LivingRoom")

      expect(equipment.name).to eq("light")
      expect(equipment.label).to eq("Lighting")
      expect(equipment.icon).to eq("light")
      expect(equipment.parent).to eq("LivingRoom")
      expect(equipment.points).to eq([])
      expect(equipment.sub_equipments).to eq([])
    end

    it "raises error if name is missing" do
      expect do
        described_class.new(label: "Lighting", icon: "light")
      end.to raise_error(ArgumentError, /missing keyword: :name/)
    end

    it "raises error if label is missing" do
      expect do
        described_class.new(name: "light", icon: "light")
      end.to raise_error(ArgumentError, /missing keyword: :label/)
    end

    it "raises error if icon is missing" do
      expect do
        described_class.new(name: "light", label: "Lighting")
      end.to raise_error(ArgumentError, /missing keyword: :icon/)
    end

    it "raises error if name is invalid" do
      expect do
        described_class.new(name: "123invalid", label: "Label", icon: "light")
      end.to raise_error(ArgumentError, /name is invalid/)
    end

    it "raises error if icon is invalid" do
      expect do
        described_class.new(name: "light", label: "Label", icon: "$$$")
      end.to raise_error(ArgumentError, /icon is invalid/)
    end
  end

  describe "#to_s" do
    it "returns string representation without parent" do
      equipment = described_class.new(name: "light", label: "Lighting", icon: "light")
      expected = 'Group light "Lighting" <light> ["Equipment"]' + "\n"
      expect(equipment.to_s).to eq(expected)
    end

    it "returns string with parent included" do
      equipment = described_class.new(name: "light", label: "Lighting", icon: "light", parent: "LivingRoom")
      expected = 'Group light "Lighting" <light> (LivingRoom) ["Equipment"]' + "\n"
      expect(equipment.to_s).to eq(expected)
    end
  end

  describe "structure constraints" do
    let(:equipment) do
      described_class.new(name: "eq1", label: "Label", icon: "icon")
    end

    it "raises error when calling #location" do
      expect { equipment.location }.to raise_error(/location cannot be nested/)
    end
  end
end
