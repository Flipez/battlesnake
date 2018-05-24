require "./battlesnake/version"
require "./battlesnake/point"
require "./battlesnake/snake"
require "./battlesnake/game"
require "kemal"

module Battlesnake
  # Configure own snake for game start
  moves = ["up", "down", "left", "right"]
  alternative_moves = {
    "up": ["left", "right"],
    "left": ["up", "down"],
    "right": ["up", "down"],
    "down": ["left", "right"]
  }
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

    points.each { |point| return false if point == target }

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
    foods = params["food"].as(Hash)["data"].as(Array).map{ |food| Point.from_hash(food.as(Hash)) }
    snakes = params["snakes"].as(Hash)["data"].as(Array).map{ |snake| Snake.new(snake.as(Hash)) }

    free_points_around = me.look_around.select { |point|
      is_free_point?(point, game, snakes)
    }

    p me.health
    next_target = if me.health >= 75_i64
                    p "head tail"
                    me.tail
                  else
                    p "head food"
                    me.nearest_food(foods)
                  end
    next_move = me.next_move(next_target)
    next_entry = me.next_point(next_move)
    p "#{next_move} to #{next_target.inspect} from #{me.head.inspect}"


    unless is_free_point?(next_entry, game, snakes)
      avail_moves = alternative_moves[next_move].dup

      avail_moves.each{ |move|
        p "alternative move: #{move}"
        next_entry = me.next_point(move)
        next_move = move if is_free_point?(next_entry, game, snakes)
      }
    end

    { "move": next_move }.to_json
end

Kemal.run
end
