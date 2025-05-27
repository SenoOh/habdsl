# frozen_string_literal: true

require "ripper"
require_relative "model/dsl"
require_relative "result_parser"

module Habdsl
  # Class that parses DSL code and generates a result.
  class BaseParser
    class DSLValidationError < StandardError; end

    def self.evaluate_dsl(input_code:, table:)
      raise DSLValidationError, "Syntax error: DSL code contains a syntax error." if Ripper.sexp(input_code).nil?

      if table.any? && !input_code.include?("table")
        raise DSLValidationError, "'table' is not used in the DSL code but table data was provided."
      end

      dsl = Habdsl::Model::Dsl.new
      defined_objects = []

      eval_context = Object.new

      eval_context.define_singleton_method(:location) do |**args, &block|
        loc = dsl.location(**args, &block)
        defined_objects << loc
        loc
      end

      eval_context.define_singleton_method(:equipment) do |**args, &block|
        eq = dsl.equipment(**args, &block)
        defined_objects << eq
        eq
      end

      eval_context.define_singleton_method(:point) do |**args|
        dsl.point(**args)
      end

      eval_context.define_singleton_method(:table) { table }

      begin
        eval_context.instance_eval(input_code)
      rescue StandardError => e
        raise DSLValidationError, "Runtime error during DSL evaluation: #{e.class} - #{e.message}"
      end

      generated_output = defined_objects.map(&:to_s).join("\n")

      if input_code.include?("table") && table.is_a?(Array) && !table.empty?
        # Check if table keys were actually used in the generated output
        unused_keys = table.first.keys.reject do |key|
          table.any? {|row| generated_output.include?(row[key].to_s) }
        end

        if unused_keys.any?
          raise DSLValidationError,
                "Validation error: The following table keys are not used in the generated DSL output: #{unused_keys.join(', ')}"
        end
      end

      ResultParser.new(table: table, dsl: generated_output)
    end
  end
end
