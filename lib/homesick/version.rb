# frozen_string_literal: true

module Homesick
  # A representation of Homesick's version number in constants, including a
  # String of the entire version number
  module Version
    MAJOR = 2
    MINOR = 0
    PATCH = 0

    STRING = [MAJOR, MINOR, PATCH].compact.join('.')
  end
end
