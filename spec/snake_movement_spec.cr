require "./spec_helper"
describe "Battlesnake" do
  it "eats shorter snake" do
    body = File.read("./spec/fixtures/game_start")
    post "/start", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body

    body = File.read("./spec/fixtures/collision_shorter_enemy")
    post "/move", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body

    response.body.should eq "{\"move\":\"down\"}"
  end

  it "avoids longer snake" do
    body = File.read("./spec/fixtures/game_start")
    post "/start", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body

    body = File.read("./spec/fixtures/collision_longer_enemy")
    post "/move", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body

    response.body.should eq "{\"move\":\"right\"}"
  end
end
