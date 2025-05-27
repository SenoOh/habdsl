# frozen_string_literal: true

module Habdsl
  module Model
    # Represents a point in the model.
    class Point
      attr_reader :name, :label, :type, :icon, :parent, :tags

      def initialize(name:, label:, type:, icon:, tags:, parent: nil, channel: nil)
        validate!(name, "name")
        validate!(type, "type")
        validate!(icon, "icon")

        @name = name
        @label = label
        @type = type
        @icon = icon
        @tags = tags
        @parent = parent
        @channel = channel
      end

      def location(*)
        raise "Error: location cannot be nested inside point"
      end

      def equipment(*)
        raise "Error: equipment cannot be nested inside point"
      end

      def to_s(parent_name = nil)
        result = "#{@type} #{@name} \"#{@label}\" <#{@icon}>"
        result += format_parent(parent_name, @parent)
        result += " [#{@tags.map {|t| "\"#{t}\"" }.join(', ')}]"
        result += " {channel=\"#{@channel}\"}" if @channel
        result += "\n"
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
