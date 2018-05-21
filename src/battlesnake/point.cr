module Battlesnake
  class Point
    property x : Int64, y : Int64

    def initialize(@x : Int64, @y : Int64)
    end

    def distance(point : Battlesnake::Point)
      x2 = (x - point.x) * (x - point.x)
      y2 = (y - point.y) * (y - point.y)
      Math.sqrt(x2 + y2)
    end
  end
end
