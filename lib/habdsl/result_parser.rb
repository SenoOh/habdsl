# frozen_string_literal: true

module Habdsl
  # The result of parsing a DSL file.
  class ResultParser
    attr_reader :table, :dsl

    def initialize(dsl:, table: nil)
      @table = table
      @dsl = dsl
    end
  end
end
