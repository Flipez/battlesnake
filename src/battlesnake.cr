require "./battlesnake/version"
require "./battlesnake/point"
require "./battlesnake/snake"
require "./battlesnake/game"
require "kemal"

module Battlesnake
  # Configure own snake for game start
  moves = ["up", "down", "left", "right"]
  game = Game.new(
           color:           "#FF0000",
           secondary_color: "#00FF00",
           head_url:        "https://www.fillmurray.com/200/200",
           taunt:           "snake.cr 1.0",
           head_type:       "pixel",
           tail_type:       "pixel"
         )

  def self.is_free_point?(target : Point, game : Game, snakes : Array(Snake))
    valid_x = 0..game.width - 1
    valid_y = 0..game.height - 1

    return false unless valid_x.covers? target.x
    return false unless valid_y.covers? target.y

    points = snakes.map{ |snake|
      snake.body
    }.flatten

    points.each { |point|
      return false if point.x == target.x && point.y == target.y
    }

    true
  end

  post "/start" do |env|
    # Expect the following json:
    #  {"width" => 20_i64, "height" => 20_i64, "game_id" => 1_i64}
    params = env.params.json

    # Set game params based on the server request
    game.id     = params["game_id"].as(Int64)
    game.height = params["height"].as(Int64)
    game.width  = params["width"].as(Int64)

    # Send own snake to register
    game.start
  end

  post "/move" do |env|
    params = env.params.json.as(Hash)
    me = Snake.new(params["you"].as(Hash))
    foods = params["food"].as(Hash)["data"].as(Array).map{ |food|
      Point.new(food.as(Hash)["x"].as(Int64),
               food.as(Hash)["y"].as(Int64))
    }
    snakes = params["snakes"].as(Hash)["data"].as(Array).map{ |snake|
      Snake.new(snake.as(Hash))
    }

    next_target = me.nearest_food(foods)
    next_move = me.next_move(next_target)
    next_entry = me.next_point(next_move)
    p next_move
    unless is_free_point?(next_entry, game, snakes)
      avail_moves = moves.dup
      avail_moves.delete(next_move)
      avail_moves.each{ |move|
        is_free = is_free_point?(me.next_point(move), game, snakes)
        p avail_moves
        p "#{move}: #{is_free}"
        if is_free
          next_move = move
        end
      }
    end
    p next_move
    { "move": next_move }.to_json
end

Kemal.run
end
