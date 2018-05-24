module Battlesnake
  class Point
    property x : Int64, y : Int64

    def initialize(@x : Int64, @y : Int64)
    end

    def ==(other_point : Point)
      return false unless other_point.is_a?(Point)

      self.x == other_point.x &&
      self.y == other_point.y
    end

    def self.from_hash(hash : Hash)
      Point.new(hash["x"].as(Int64), hash["y"].as(Int64))
    end

    def distance(point : Battlesnake::Point)
      x2 = (x - point.x) * (x - point.x)
      y2 = (y - point.y) * (y - point.y)
      Math.sqrt(x2 + y2)
    end
  end
end
