# frozen_string_literal: true

require_relative "location"
require_relative "equipment"
require_relative "point"

module Habdsl
  module Model
    # DSL for defining locations, equipment, and points
    class Dsl
      def location(name:, label:, icon:, parent: nil, &)
        loc = Habdsl::Model::Location.new(name: name, label: label, icon: icon, parent: parent)
        loc.instance_eval(&) if block_given?
        loc
      end

      def equipment(name:, label:, icon:, parent: nil, &)
        eq = Habdsl::Model::Equipment.new(name: name, label: label, icon: icon, parent: parent)
        eq.instance_eval(&) if block_given?
        eq
      end

      def point(name:, label:, type:, icon:, tags:, parent: nil, channel: nil)
        Habdsl::Model::Point.new(name: name, label: label, type: type, icon: icon, tags: tags, parent: parent,
                                 channel: channel)
      end
    end
  end
end
