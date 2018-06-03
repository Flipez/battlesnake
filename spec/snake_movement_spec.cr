require "./spec_helper"
describe "Battlesnake" do
  it "eats shorter snake" do
    post "/start", headers: Memoized.header, body: File.read("./spec/fixtures/game_start")

    post "/move", headers: Memoized.header, body: File.read("./spec/fixtures/collision_shorter_enemy")

    response.body.should contain "down"
  end

  it "avoids longer snake" do
    post "/start", headers: Memoized.header, body: File.read("./spec/fixtures/game_start")

    post "/move", headers: Memoized.header, body: File.read("./spec/fixtures/collision_longer_enemy")

    response.body.should contain "right"
  end
end
