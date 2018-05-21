require "./battlesnake/version"
require "./battlesnake/snake"
require "./battlesnake/me"
require "./battlesnake/enemy"
require "./battlesnake/game"
require "kemal"

moves = ["up", "up", "right", "right", "down",  "down", "left", "left"]
next_move = 0

# Configure own snake for game start
me = Battlesnake::Me.new(
       color:           "#FF0000",
       secondary_color: "#00FF00",
       head_url:        "https://www.fillmurray.com/200/200",
       taunt:           "Was 1 Nice Snake am start been",
       head_type:       "pixel",
       tail_type:       "pixel"
     )
game = Battlesnake::Game.new(me)


post "/start" do |env|
  # Expect the following json:
  #  {"width" => 20_i64, "height" => 20_i64, "game_id" => 1_i64}
  params = env.params.json

  # Set game params based on the server request
  game.id     = params["game_id"].as(Int64)
  game.height = params["height"].as(Int64)
  game.width  = params["width"].as(Int64)

  p game

  # Send own snake to register
  game.me.to_json
end

post "/move" do |env|
  game.update(env.params.json)

  p game

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
