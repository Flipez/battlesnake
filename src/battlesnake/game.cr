module Battlesnake
  class Game
    property id              : Int64
    property height          : Int64
    property width           : Int64
    property turn            : Int64
    property color           : String
    property secondary_color : String
    property head_url        : String
    property taunt           : String
    property head_type       : String
    property tail_type       : String

    def initialize(@color, @secondary_color, @head_url, @taunt, @head_type, @tail_type)
      @id     = 0_i64
      @height = 0_i64
      @width  = 0_i64
      @turn   = 0_i64
    end

    def start
      {
        color: color,
        secondary_color: secondary_color,
        head_url: head_url,
        taunt: taunt,
        head_type: head_type,
        tail_type: tail_type
      }.to_json
    end
  end
end
