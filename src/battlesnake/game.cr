module Battlesnake
  class Game
    TAUNTS = ["buttert euch weg",
              "fly am been",
              "feiert das",
              "ist 1 nice schlängli",
              "Severus Snake"]

    property id              : Int64
    property height          : Int64
    property width           : Int64
    property turn            : Int64
    property color           : String

    def initialize
      @color = "#FC5299"
      @id     = 0_i64
      @height = 0_i64
      @width  = 0_i64
      @turn   = 0_i64
    end

    def center
      x = 1_i64..width
      y = 1_i64..height

      x_center = x.to_a[x.size / 2]
      y_center = y.to_a[y.size / 2]

      Point.new(x_center, y_center)
    end

    def start
      {
        color: color,
      }.to_json
    end
  end
end
