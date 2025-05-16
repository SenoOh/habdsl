# frozen_string_literal: true

require "spec_helper"
require_relative "../../../../lib/habdsl/model/location"
require_relative "../../../../lib/habdsl/model/equipment"

RSpec.describe Habdsl::Model::Location do
  describe "#initialize" do
    it "creates a valid Location with all parameters" do
      location = described_class.new(name: "livingroom", label: "Living Room", icon: "sofa", parent: "house")

      expect(location.name).to eq("livingroom")
      expect(location.label).to eq("Living Room")
      expect(location.icon).to eq("sofa")
      expect(location.parent).to eq("house")
      expect(location.sub_locations).to eq([])
      expect(location.equipments).to eq([])
    end

    it "raises error if name is missing" do
      expect do
        described_class.new(label: "Living Room", icon: "sofa")
      end.to raise_error(ArgumentError, /missing keyword: :name/)
    end

    it "raises error if label is missing" do
      expect do
        described_class.new(name: "livingroom", icon: "sofa")
      end.to raise_error(ArgumentError, /missing keyword: :label/)
    end

    it "raises error if icon is missing" do
      expect do
        described_class.new(name: "livingroom", label: "Living Room")
      end.to raise_error(ArgumentError, /missing keyword: :icon/)
    end

    it "raises error if name is invalid" do
      expect do
        described_class.new(name: "123invalid", label: "Room", icon: "house")
      end.to raise_error(ArgumentError, /name is invalid/)
    end

    it "raises error if icon is invalid" do
      expect do
        described_class.new(name: "livingroom", label: "Room", icon: "$$$")
      end.to raise_error(ArgumentError, /icon is invalid/)
    end
  end

  describe "#to_s" do
    it "returns string representation without parent" do
      location = described_class.new(name: "livingroom", label: "Living Room", icon: "sofa")
      expected = 'Group livingroom "Living Room" <sofa> ["Location"]' + "\n"
      expect(location.to_s).to eq(expected)
    end

    it "returns string with parent included" do
      location = described_class.new(name: "livingroom", label: "Living Room", icon: "sofa", parent: "house")
      expected = 'Group livingroom "Living Room" <sofa> (house) ["Location"]' + "\n"
      expect(location.to_s).to eq(expected)
    end
  end

  describe "structure constraints" do
    let(:location) do
      described_class.new(name: "livingroom", label: "Living Room", icon: "sofa")
    end

    it "raises error when calling #point" do
      expect { location.point }.to raise_error(/point cannot be directly under location/)
    end
  end
end
