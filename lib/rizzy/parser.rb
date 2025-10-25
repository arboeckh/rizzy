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
      add_entry(tag, value, data) unless tag.nil? || value.nil?
    end
    Reference.new(**data)
  end

  def self.add_entry(tag, entry, data)
    case tag
    when "TY"
      data[:type] = entry
    when "DB"
      data[:database] = entry
    when "ID"
      data[:id] = entry
    when "DO"
      data[:doi] = entry
    when "T1", "TI"
      data[:title] = entry
    when "Y1", "PY"
      data[:year] = entry
    when "N2", "AB"
      data[:abstract] = entry
    when "M3"
      data[:type_of_work] = entry
    when "JF"
      data[:journal_full] = entry
    when "VL"
      data[:volume] = entry
    when "IS"
      data[:issue] = entry
    when "SP"
      data[:start_page] = entry
    when "EP"
      data[:end_page] = entry
    when "CY"
      data[:country] = entry
    when "SN"
      data[:isbn] = entry
    when "NL"
      data[:alternate_journal] = entry
    when "LA"
      data[:language] = entry
    when "PT"
      data[:publication_type] = entry
    when "A1", "AU"
      data[:authors] << entry
    when "AI"
      data[:author_identifiers] << entry
    when "A2"
      data[:secondary_authors] << entry
    when "KW"
      data[:keywords] << entry
    when "PB"
      data[:publishers] << entry
    when "AD"
      data[:addresses] << entry
    when "M1"
      data[:miscellaneous_ones] << entry
    when "M2"
      data[:miscellaneous_twos] << entry
    when "L2", "UR"
      data[:urls] << entry
    end
  end

  private_class_method :normalize_encoding
end
