require "./battlesnake/version"
require "./battlesnake/point"
require "./battlesnake/snake"
require "./battlesnake/game"
require "kemal"
require "logger"

module Battlesnake
  LOGGER = Logger.new(STDOUT)
  LOGGER.level = Logger::DEBUG

  # Configure own snake for game start
  moves = ["up", "down", "left", "right"]
  alternative_moves = {
    "up": ["left", "right"],
    "left": ["up", "down"],
    "right": ["up", "down"],
    "down": ["left", "right"]
  }
  game = Game.new

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

    foods = params["food"].as(Hash)["data"].as(Array).map{ |food| Point.from_hash(food.as(Hash)) }
    me = Snake.new(params["you"].as(Hash), foods, game)
    snakes = params["snakes"].as(Hash)["data"].as(Array).map { |snake|
      Snake.new(snake.as(Hash), foods, game)
    }

    free_points_around = me.look_around.select { |point|
      is_free_point?(point, game, snakes)
    }

    next_move = me.next_move(me.next_target(snakes))
    next_entry = me.next_point(next_move)


    unless is_free_point?(next_entry, game, snakes)
      avail_moves = alternative_moves[next_move].dup

      avail_moves.each{ |move|
        LOGGER.debug("alternative move: #{move}")
        next_entry = me.next_point(move)
        next_move = move if is_free_point?(next_entry, game, snakes)
      }
    end

    { "move": next_move }.to_json
end

Kemal.run
end
