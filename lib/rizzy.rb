# frozen_string_literal: true

require_relative "rizzy/version"

module Rizzy
  class Error < StandardError; end
  
  def self.greet(name)
    return "Hello, stranger!" if name.nil? || name.empty?

    "Hello, #{name}! Welcome to rizzy"
  end
  
end
