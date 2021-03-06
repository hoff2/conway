module Conway
  # the current state of a Conway's Game Of Life
  class World
    def self.empty
      new([])
    end

    def self.from_coordinate_list(coordinates)
      empty.add_cells(coordinates.map { |xy|
        LiveCell.at(xy[0], xy[1])
      })
    end

    def initialize(cells)
      @cells_by_location = {}
      add_cells(cells)
    end

    attr_reader :cells_by_location

    def cells
      cells_by_location.values
    end

    def cell_count
      cells.count
    end

    def add_cell(cell)
      unless cell_at?(cell.location)
        cells_by_location[cell.location] = cell
      end
      self
    end

    def add_cells(cells)
      cells.each { |cell| add_cell(cell) }
      self
    end

    def cell_at?(location)
      !cells_by_location[location].nil?
    end

    def neighborhood_of(loc)
      [Location.new(loc.x - 1, loc.y - 1),
       Location.new(loc.x - 1, loc.y),
       Location.new(loc.x - 1, loc.y + 1),
       Location.new(loc.x, loc.y - 1),
       Location.new(loc.x, loc.y + 1),
       Location.new(loc.x + 1, loc.y - 1),
       Location.new(loc.x + 1, loc.y),
       Location.new(loc.x + 1, loc.y + 1)]
    end

    def count_neighbors_of(cell)
      count_neighbors_at(cell.location)
    end

    def count_neighbors_at(location)
      neighborhood_of(location).select { |loc| cell_at?(loc) }.count
    end

    def candidate_locations
      cells.map { |cell|
        neighborhood_of(cell.location) + [cell.location]
      }.flatten.uniq
    end

    def lives_next_tick?(location)
      (cell_at?(location) &&
        count_neighbors_at(location) == 2
      ) || count_neighbors_at(location) == 3
    end

    def tick
      new_cells = candidate_locations.select { |location|
        lives_next_tick?(location)
      }.uniq.map { |location|
        LiveCell.at_location(location)
      }
      World.new(new_cells)
    end
  end

  # a location within the game grid
  class Location
    attr_reader :x, :y

    def initialize(x, y)
      @x, @y = x, y
    end

    def ==(other)
      @x == other.x && @y == other.y
    end

    def <=>(other)
      [@x, @y] <=> [other.x, other.y]
    end

    def to_s
      "#{@x},#{@y}"
    end

    def to_array
      [@x, @y]
    end

    def hash
      to_array.hash
    end

    def eql?(other)
      to_array == other.to_array
    end
  end

  # represents the fact that a live cell exists at a location
  class LiveCell
    attr_reader :location

    def self.at(x, y)
      at_location(Location.new(x, y))
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
