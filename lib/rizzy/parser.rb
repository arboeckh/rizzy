# frozen_string_literal: true

require_relative "reference"

# Rizzy parsing logic
module Rizzy
  def self.parse(content)
    str = normalize_encoding(content)
    lines = str.lines
  end

  def self.normalize_encoding(string)
    str = string.dup
    return str if str.encoding.name == "UTF-8" && str.valid_encoding?

    str.encode("UTF-8")
  end

  private_class_method :normalize_encoding
end
