require_relative "reference"

module Rizzy
  def self.parse(content)
    normalize_encoding(content)
  end

  def self.normalize_encoding(string)
    str = string.dup

    return str if str.encoding.name == "UTF-8" && str.valid_encoding?

    raise Rizzy::EncodingError,
          "RIS content must be in UTF-8 encoding"
  end

  private_class_method :normalize_encoding
end
