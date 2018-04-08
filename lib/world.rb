module Conway
  class World
    def self.empty
      self.new({})
    end

    def self.from_coordinate_list(coordinates)
      empty.add_cells(coordinates.map{ |xy|
        LiveCell.at(xy[0], xy[1])
      })
    end

    def initialize(cells)
      @cells = {}
      add_cells(cells)
    end

    attr_reader :cells

    def cell_count
      @cells.count
    end

    def add_cell(cell)
      unless has_cell_at?(cell.location)
        @cells[cell.location.to_array] = cell
      end
      self
    end

    def add_cells(cells)
      cells.each{ |cell| add_cell(cell) }
      self
    end

    def has_cell_at?(location)
      !@cells[location.to_array].nil?
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
      neighborhood_of(location).select{ |loc| has_cell_at?(loc) }.count
    end

    def candidate_locations
      @cells.values.map{ |cell|
        neighborhood_of(cell.location) + [cell.location]
      }.flatten.uniq{ |loc| loc.to_array }
    end

    def lives_next_tick?(location)
      ( has_cell_at?(location) &&
        count_neighbors_at(location) == 2) ||
      count_neighbors_at(location) == 3
    end

    def tick
      new_locations = candidate_locations.select{ |location|
          lives_next_tick?(location)
      }.uniq
      cells = new_locations.map{ |location|
        LiveCell.at_location(location)
      }
      World.new(cells)
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

    def <=>(loc)
      [@x, @y] <=> [loc.x, loc.y]
    end

    def to_s
      "#{@x},#{@y}"
    end

    # helper function for filtering out duplicate locations
    # because Array#uniq doesn't use == :(
    def to_array
      [@x, @y]
    end
  end

  class LiveCell
    attr_reader :location

    def self.at(x, y)
      at_location(Location.new(x,y))
    end

    def self.at_location(loc)
      new(loc)
    end

    def initialize(location)
      @location = location
    end

    def to_s
      @location.to_s
    end
  end
end



