# frozen_string_literal: true

module Habdsl
  module Model
    # Represents a piece of equipment in the DSL.
    class Equipment
      attr_reader :name, :label, :icon, :parent, :points, :sub_equipments

      def initialize(name:, label:, icon:, parent: nil)
        validate!(name, "name")
        validate!(icon, "icon")

        @name = name
        @label = label
        @icon = icon
        @parent = parent
        @points = []
        @sub_equipments = []
      end

      def equipment(name:, label:, icon:, parent: nil, &)
        eq = Equipment.new(name: name, label: label, icon: icon, parent: parent)
        eq.instance_eval(&) if block_given?
        @sub_equipments << eq
      end

      def point(name:, label:, type:, icon:, tags:, parent: nil, channel: nil)
        @points << Point.new(name: name, label: label, type: type, icon: icon, tags: tags, parent: parent,
                             channel: channel)
      end

      def location(*)
        raise "Error: location cannot be nested inside equipment"
      end

      def to_s(parent_name = nil)
        result = "Group #{@name} \"#{@label}\" <#{@icon}>"
        result += format_parent(parent_name, @parent)
        result += " [\"Equipment\"]\n"

        @sub_equipments.each {|sub_eq| result += sub_eq.to_s(@name) }
        @points.each {|pt| result += pt.to_s(@name) }

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
