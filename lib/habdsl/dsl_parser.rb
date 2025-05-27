# frozen_string_literal: true

require "ripper"
require_relative "model/dsl"
require_relative "result_parser"

module Habdsl
  # DSLのみを評価してopenHAB設定DSLを生成するパーサ
  class DslParser
    class DSLValidationError < StandardError; end

    def self.parse(input_code:)
      raise DSLValidationError, "Syntax error: DSL code contains a syntax error." if Ripper.sexp(input_code).nil?

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

      eval_context.instance_eval(input_code)

      generated_output = defined_objects.map(&:to_s).join("\n")

      ResultParser.new(dsl: generated_output, table: nil)
    end
  end
end
