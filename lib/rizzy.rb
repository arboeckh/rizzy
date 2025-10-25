# frozen_string_literal: true

require_relative "rizzy/version"
require_relative "rizzy/parser"
require_relative "rizzy/writer"

module Rizzy
  class Error < StandardError; end
  class EncodingError < StandardError; end
end
