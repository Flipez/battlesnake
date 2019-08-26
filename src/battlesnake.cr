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
  game = Game.new

  def self.is_free_point?(target : Point, game : Game, snakes : Array(Snake), me : Snake)
    valid_x = 0..game.width - 1
    valid_y = 0..game.height - 1

    return false unless valid_x.covers? target.x
    return false unless valid_y.covers? target.y

    # get all enemie snakes
    enemies = snakes.reject { |s| s.id == me.id }

    occupied_points = [] of Battlesnake::Point

    # Add the current position of each snake including me as occupied
    snakes.each do |snake|
      occupied_points += snake.body
    end

    # Try to predict enemy movement
    enemies.each do |enemy|
      if enemy.length >= me.length
        enemy_move = enemy.next_move(enemy.nearest_food)
        occupied_points << enemy.next_point(enemy_move)
      end
    end

    occupied_points.flatten.each do |point|
      return false if point == target
    end

    true
  end

  post "/start" do |env|
    # Expect the following json:
    #  {"width" => 20_i64, "height" => 20_i64, "game_id" => 1_i64} # 2018
    params = env.params.json

    dump = File.new "start", "w"
    dump.puts env.params.json.to_json
    dump.close

    # Set game params based on the server request
    board = params["board"].as(Hash)

    game.id     = params["game"].as(Hash)["id"].as(Int64)
    game.height = board["height"].as(Int64)
    game.width  = board["width"].as(Int64)

    # Send own snake to register
    game.start
  end

  post "/move" do |env|
    params = env.params.json.as(Hash)
    game.turn = params["turn"].as(Int64)

    dump = File.new "turn", "w"
    dump.puts env.params.json.to_json
    dump.close


    foods = params["board"].as(Hash)["food"].as(Array).map{ |food| Point.from_hash(food.as(Hash)) }
    me = Snake.new(params["you"].as(Hash), foods, game)
    snakes = params["board"].as(Hash)["snakes"].as(Array).map do |snake|
      Snake.new(snake.as(Hash), foods, game)
    end

    free_points_around = me.look_around.select do |point|
      is_free_point?(point, game, snakes, me)
    end

    next_target = me.next_target(snakes)
    next_point = free_points_around.sort_by do |point|
      point.distance(next_target)
    end.first

    next_move = me.next_move(next_point)

    { "move": next_move }.to_json
end

Kemal.run
end
