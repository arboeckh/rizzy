# frozen_string_literal: true

require_relative "reference"

# Rizzy parsing logic
module Rizzy
  def self.parse(content)
    str = normalize_encoding(content)
    entries = str.split("ER  -")
    references = []
    entries.each do |entry|
      references << process_entry(entry)
    end
    references
  end

  def self.normalize_encoding(string)
    str = string.dup
    return str if str.encoding.name == "UTF-8" && str.valid_encoding?

    str.encode("UTF-8")
  end

  def self.process_entry(entry)
    data = Hash.new { |h, k| h[k] = [] if k.to_s.end_with?("s") }
    lines = entry.lines
    lines.each do |line|
      elements = line.split("  - ")
      next if elements.length != 2

      tag = elements[0]
      value = elements[1].strip
      add_entry(tag, value, data)
    end
    Reference.new(**data)
  end

  def self.add_entry(tag, entry, data)
    case tag
    when "TY"
      data[:type] = entry
    when "DB"
      data[:database] = entry
    when "A1"
      data[:authors] << entry
    end
  end

  private_class_method :normalize_encoding
end
