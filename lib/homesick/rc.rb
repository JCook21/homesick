# frozen_string_literal: true

require 'pathname'

module Homesick
  module RC
    # Evaluation context for .homesickrc scripts.
    #
    # Runs castle setup scripts in a clean object rather than in the
    # Homesick::CLI binding, so scripts cannot access CLI internals.
    # Standard Ruby library methods (File, Dir, system, etc.) remain
    # available to scripts.
    class Context
      # @param castle_path [Pathname, String] absolute path to the castle root
      def initialize(castle_path)
        @castle_path = Pathname.new(castle_path)
      end

      # The absolute path of the castle being configured.
      attr_reader :castle_path

      # Execute a shell command.
      # @param command [String]
      # @return [Boolean] true if the command succeeded
      def run(command)
        system(command)
      end
    end
  end
end
