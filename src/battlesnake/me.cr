module Battlesnake
  class Me < Snake
    def to_json
      {
        color: color,
        secondary_color: secondary_color,
        head_url: head_url,
        taunt: taunt,
        head_type: head_type,
        tail_type: tail_type
      }.to_json
    end
  end
end
