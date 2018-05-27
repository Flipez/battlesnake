module Battlesnake
  class Snake
    MOVES = { "up": 0, "down": 0, "left": 0, "right": 0 }

    property name   : String
    property taunt  : String
    property length : Int64
    property id     : String
    property health : Int64
    property body   : Array(Battlesnake::Point)
    property foods  : Array(Battlesnake::Point)

    def initialize(params, @foods)
      @name = params["name"].as(String)
      @taunt = params["taunt"].to_s.as(String)
      @length = params["length"].as(Int64)
      @id = params["id"].as(String)
      @health = params["health"].as(Int64)
      @body = params["body"].as(Hash)["data"].as(Array).map{ |point|
        Point.new(point.as(Hash)["x"].as(Int64),
                  point.as(Hash)["y"].as(Int64))
      }
    end

    def head
      body.first
    end

    def tail
      body.last
    end

    def nearest_food
      foods_distance = {} of Float64 => Point
      foods.each{ |food|
        foods_distance[food.distance(body.first)] = food
      }
      min = foods_distance.keys.min
      foods_distance[min]
    end

    def look_around(radius=1)
      x = (head.x - radius..head.x + radius).to_a
      y = (head.y - radius..head.y + radius).to_a
      around = x.product(y)
      around.map{ |x,y|
        Point.new(x.as(Int64),y.as(Int64))
      }
    end

    def next_point(move : String)
      point = Point.new(head.x, head.y)

      case move
      when "up"
        point.y -= 1
      when "right"
        point.x += 1
      when "down"
        point.y += 1
      when "left"
        point.x -= 1
      end

      point
    end

    def next_target(snakes)
      snakes.reject{|s| s.id == id}
      LOGGER.debug("Got #{snakes.size} enemy snakes")
      enemy_distance = snakes.map { |s|
        s.head.distance(nearest_food)
      }

      enemy_closer = enemy_distance.any? { |dist|
        head.distance(nearest_food) > dist
      }

      if enemy_closer
        LOGGER.debug("head tail")
        tail
      else
        LOGGER.debug("head food")
        nearest_food
      end
    end

    def next_move(point : Point)
      if head.x == point.x
        if head.y < point.y
          "down"
        else
           "up"
         end
      else
        if head.x < point.x
          "right"
        else
          "left"
        end
      end
    end
  end

end
