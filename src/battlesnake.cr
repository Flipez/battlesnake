require "./battlesnake/*"
require "kemal"

module Battlesnake
  moves = ["up", "up", "right", "right", "down",  "down", "left", "left"]
  next_move = 0

  before_post "/start" do |env|
    puts "Setting response content type"
    env.response.content_type = "application/json"
  end
  post "/start" do
    {
     color: "#FF0000",
     secondary_color: "#00FF00",
     head_url: "http://placecage.com/c/100/100",
     taunt: "OH GOD NOT THE BEES",
     head_type: "pixel",
     tail_type: "pixel"
    }.to_json
  end
  
  before_post "/move" do |env|
    puts "Setting response content type"
    env.response.content_type = "application/json"
  end
  post "/move" do |env|
    params = env.params.json
    name = params["you"].as(Hash)["name"]
    snakes = params["snakes"].as(Hash)
    enemies = snakes["data"].as(Array).select { |snake|
      snake.as(Hash)["name"].as(String) != name
    }.as(Array)
    next_move = if moves.size() - 1 == next_move
      0
    else
      next_move + 1
    end

    {
      "move": moves[next_move]
    }.to_json
  end

  Kemal.run
end
