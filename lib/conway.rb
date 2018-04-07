module Conway
  class World
    def self.empty
      self.new([])
    end

    def initialize(cells)
      @cells = cells
    end

    def cell_count
      @cells.count
    end

    def add_cell(cell)
      unless @cells.any?{ |c| c.location == cell.location }
        @cells << cell
      end
    end

    def has_cell_at?(location)
      @cells.any?{ |cell| cell.location == location }
    end

    def neighborhood_of(loc)
      [ Location.new(loc.x - 1, loc.y - 1),
        Location.new(loc.x - 1, loc.y),
        Location.new(loc.x - 1, loc.y + 1),
        Location.new(loc.x, loc.y - 1),
        Location.new(loc.x, loc.y + 1),
        Location.new(loc.x + 1, loc.y - 1),
        Location.new(loc.x + 1, loc.y),
        Location.new(loc.x + 1, loc.y + 1) ]
    end

    def count_neighbors_of(cell)
      count_neighbors_at(cell.location)
    end

    def count_neighbors_at(location)
      @cells.count{ |cell| neighborhood_of(location).include?(cell.location)}
    end

    def candidate_locations
      @cells.map{ |cell|
        neighborhood_of(cell.location) + [cell.location]
      }.flatten.uniq
    end

    def tick
      World.new(
        candidate_locations.select{ |location|
          ( has_cell_at?(location) &&
            count_neighbors_at(location) == 2) ||
          count_neighbors_at(location) == 3
        }.map{ |location|
          LiveCell.at(location)
        }.uniq)
    end
  end

  class Location
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
    end

    def ==(loc)
      @x == loc.x && @y == loc.y
    end

    def to_s
      "(#{@x}, #{@y})"
    end
  end

  class LiveCell
    attr_reader :location

    def self.at(x, y)
      new(Location.new(x,y))
    end

    def initialize(location)
      @location = location
    end
  end
end



