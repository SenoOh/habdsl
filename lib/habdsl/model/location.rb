# frozen_string_literal: true

module Habdsl
  module Model
    # Represents a location in the structure.
    class Location
      attr_reader :name, :label, :icon, :parent, :sub_locations, :equipments

      def initialize(name:, label:, icon:, parent: nil)
        validate!(name, "name")
        validate!(icon, "icon")

        @name = name
        @label = label
        @icon = icon
        @parent = parent
        @sub_locations = []
        @equipments = []
      end

      def location(name:, label:, icon:, parent: nil, &)
        loc = Location.new(name: name, label: label, icon: icon, parent: parent)
        loc.instance_eval(&) if block_given?
        @sub_locations << loc
      end

      def equipment(name:, label:, icon:, parent: nil, &)
        eq = Equipment.new(name: name, label: label, icon: icon, parent: parent)
        eq.instance_eval(&) if block_given?
        @equipments << eq
      end

      def point(*)
        raise "Error: point cannot be directly under location. Use equipment to wrap it."
      end

      def to_s(parent_name = nil)
        result = "Group #{@name} \"#{@label}\" <#{@icon}>"
        result += format_parent(parent_name, @parent)
        result += " [\"Location\"]\n"

        @sub_locations.each {|sub_loc| result += sub_loc.to_s(@name) }
        @equipments.each {|eq| result += eq.to_s(@name) }

        result
      end

      private

      def validate!(value, field)
        return if value.nil?
        return if value.match?(/\A[a-zA-Z_][a-zA-Z0-9_]*\z/)

        raise ArgumentError, "#{field} is invalid: '#{value}'"
      end

      def format_parent(structure_parent, explicit_parent)
        return "" if structure_parent.nil? && explicit_parent.nil?

        values = [structure_parent, explicit_parent].compact
        " (#{values.join(', ')})"
      end
    end
  end
end
