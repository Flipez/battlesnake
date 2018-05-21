module Battlesnake
  class Game
    property id      : Int64
    property height  : Int64
    property width   : Int64
    property me      : Battlesnake::Me
    property enemies : Array(Battlesnake::Enemy)

    def initialize(@me)
      @id     = 0_i64
      @height = 0_i64
      @width  = 0_i64
      @enemies = [] of Battlesnake::Enemy
    end

    def update(params)
      update_me params["you"].as(Hash)
    end

    private def update_me(new_me : Hash)
      me.length = new_me["length"].as(Int64)
      me.id     = new_me["id"].as(String)
      me.health = new_me["health"].as(Int64)
    end
  end
end
