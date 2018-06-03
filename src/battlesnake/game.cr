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
    property secondary_color : String
    property head_url        : String
    property head_type       : String
    property tail_type       : String
    property taunt           : String

    def initialize
      @color = "#FC5299"
      @secondary_color = "#52FCB5"
      @head_url = "http://steamavatars.co/wp-content/uploads/2016/01/funny_doge_steam_avatars.jpg"
      @head_type = "pixel"
      @tail_type = "pixel"
      @id     = 0_i64
      @height = 0_i64
      @width  = 0_i64
      @turn   = 0_i64
      @taunt  = ""
    end

    def center
      x = 1_i64..width
      y = 1_i64..height

      x_center = x.to_a[x.size / 2]
      y_center = y.to_a[y.size / 2]

      Point.new(x_center, y_center)
    end

    def start
      self.taunt = "#{TAUNTS.sample} (Battlesnake.cr v#{VERSION})"
      {
        color: color,
        secondary_color: secondary_color,
        head_url: head_url,
        taunt: self.taunt,
        head_type: head_type,
        tail_type: tail_type
      }.to_json
    end
  end
end
