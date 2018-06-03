require "spec-kemal"
require "../src/battlesnake"

module Memoized
  def self.header
    @@header ||= HTTP::Headers{"Content-Type" => "application/json"}
  end
end
