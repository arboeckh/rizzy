# frozen_string_literal: true

require_relative "reference"

# Rizzy parsing logic
module Rizzy
  TAG_TO_FIELD = {
    "TY" => { attr: :type, multiple: false },
    "DB" => { attr: :database, multiple: false },
    "ID" => { attr: :id, multiple: false },
    "DO" => { attr: :doi, multiple: false },
    "T1" => { attr: :title, multiple: false },
    "TI" => { attr: :title, multiple: false },
    "Y1" => { attr: :year, multiple: false },
    "PY" => { attr: :year, multiple: false },
    "N2" => { attr: :abstract, multiple: false },
    "AB" => { attr: :abstract, multiple: false },
    "M3" => { attr: :type_of_work, multiple: false },
    "JF" => { attr: :journal_full, multiple: false },
    "VL" => { attr: :volume, multiple: false },
    "IS" => { attr: :issue, multiple: false },
    "SP" => { attr: :start_page, multiple: false },
    "EP" => { attr: :end_page, multiple: false },
    "CY" => { attr: :country, multiple: false },
    "SN" => { attr: :isbn, multiple: false },
    "NL" => { attr: :alternate_journal, multiple: false },
    "LA" => { attr: :language, multiple: false },
    "PT" => { attr: :publication_type, multiple: false },
    "A1" => { attr: :authors, multiple: true },
    "AU" => { attr: :authors, multiple: true },
    "AI" => { attr: :author_identifiers, multiple: true },
    "A2" => { attr: :secondary_authors, multiple: true },
    "KW" => { attr: :keywords, multiple: true },
    "PB" => { attr: :publishers, multiple: true },
    "AD" => { attr: :addresses, multiple: true },
    "M1" => { attr: :miscellaneous_ones, multiple: true },
    "M2" => { attr: :miscellaneous_twos, multiple: true },
    "L2" => { attr: :urls, multiple: true },
    "UR" => { attr: :urls, multiple: true }
  }.freeze

  def self.parse(content)
    str = normalize_encoding(content)
    entries = str.split("ER  -")
    references = []
    entries.each do |entry|
      reference = process_entry(entry)
      references << process_entry(entry) unless reference[:type].nil?
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

      add_entry(elements[0], elements[1].strip, data)
    end
    Reference.new(**data)
  end

  def self.add_entry(tag, entry, data)
    mapping = TAG_TO_FIELD[tag]
    return if mapping.nil?

    attr = mapping[:attr]
    if mapping[:multiple]
      data[attr] << entry
    else
      data[attr] = entry
    end
  end

  private_class_method :normalize_encoding
end
