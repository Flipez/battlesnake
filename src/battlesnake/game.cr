module Battlesnake
  class Game
    property id     : Int64
    property height : Int64
    property width  : Int64
    property me     : Battlesnake::Snake
    property snakes : Array(Battlesnake::Snake)

    def initialize(@me)
      @id     = 0_i64
      @height = 0_i64
      @width  = 0_i64
      @snakes = [] of Battlesnake::Snake
    end

    def update(params)
      new_me    = params["you"].as(Hash)

      me.length = new_me["length"].as(Int64)
      me.id     = new_me["id"].as(String)
      me.health = new_me["health"].as(Int64)
    end
  end
end
