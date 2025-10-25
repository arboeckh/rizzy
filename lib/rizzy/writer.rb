# frozen_string_literal: true

# rubocop:disable all
require_relative "reference"

# Rizzy writing logic
module Rizzy
  FIELD_TO_TAG = {
    type: { tag: "TY", multiple: false },
    database: { tag: "DB", multiple: false },
    id: { tag: "ID", multiple: false },
    doi: { tag: "DO", multiple: false },
    title: { tag: "T1", multiple: false },
    year: { tag: "Y1", multiple: false },
    abstract: { tag: "N2", multiple: false },
    type_of_work: { tag: "M3", multiple: false },
    journal_full: { tag: "JF", multiple: false },
    volume: { tag: "VL", multiple: false },
    issue: { tag: "IS", multiple: false },
    start_page: { tag: "SP", multiple: false },
    end_page: { tag: "EP", multiple: false },
    country: { tag: "CY", multiple: false },
    isbn: { tag: "SN", multiple: false },
    alternate_journal: { tag: "NL", multiple: false },
    language: { tag: "LA", multiple: false },
    publication_type: { tag: "PT", multiple: false },
    authors: { tag: "A1", multiple: true },
    author_identifiers: { tag: "AI", multiple: true },
    secondary_authors: { tag: "A2", multiple: true },
    keywords: { tag: "KW", multiple: true },
    publishers: { tag: "PB", multiple: true },
    addresses: { tag: "AD", multiple: true },
    miscellaneous_ones: { tag: "M1", multiple: true },
    miscellaneous_twos: { tag: "M2", multiple: true },
    urls: { tag: "L2", multiple: true }
  }.freeze

  def self.write(references)
    references = [references] unless references.is_a?(Array)

    output = []
    references.each do |reference|
      output << write_reference(reference)
    end

    output.join("\n")
  end

  def self.write_reference(reference)
    lines = []

    FIELD_TO_TAG.each do |field, config|
      value = reference[field]
      next if value.nil?

      tag = config[:tag]

      if config[:multiple]
        next if value.empty?
        value.each do |item|
          lines << format_line(tag, item)
        end
      else
        next if value.to_s.empty?
        lines << format_line(tag, value)
      end
    end

    lines << "ER  -"
    lines.join("\n")
  end

  def self.format_line(tag, value)
    "#{tag}  - #{value}"
  end

  private_class_method :write_reference, :format_line
end
