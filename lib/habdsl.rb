# frozen_string_literal: true

require_relative "habdsl/version"
require_relative "habdsl/model/dsl"
require_relative "habdsl/base_parser"
require_relative "habdsl/dsl_parser"
require_relative "habdsl/json_parser"
require_relative "habdsl/result_parser"
require_relative "habdsl/sheet_parser"

# Habdsl is a DSL (Domain-Specific Language) for defining and parsing
# structured data in a human-readable format. It provides a way to create
# and manipulate data structures using a simple and intuitive syntax.
#
# The library includes parsers for converting DSL code into JSON format,
# as well as for parsing JSON data into structured objects.
#
# @example Basic Usage
#   require "habdsl"
#
#   dsl_code = <<~DSL
#     # Your DSL code here
#   DSL
#
#   json_code = <<~JSON
#     # Your JSON code here
#   JSON
#
#   parser = Habdsl::JsonParser.new
#   result = parser.parse(input_code: dsl_code, json_code: json_code)
#
#   puts result.table
#   puts result.dsl
module Habdsl
  class Error < StandardError; end
  # Your code goes here...
  # You can define additional convenience methods or constants here if needed.
end
