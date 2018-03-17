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



require 'minitest/autorun'
require 'minitest/spec'

class TestWorld < Minitest::Test

  include Conway

  def setup
    @world = World.empty
  end

  def test_start_with_an_empty_world
    assert_equal(0, @world.cell_count)
  end

  def test_live_cells_can_be_added_to_world
    cell = LiveCell.at(0, 0)
    @world.add_cell(cell)
    assert_equal(1, @world.cell_count)
  end

  def test_world_can_be_queried
    refute(@world.has_cell_at?(Location.new(0, 0)))
    @world.add_cell(LiveCell.at(0, 0))
    assert(@world.has_cell_at?(Location.new(0, 0)))
  end

  def test_world_allows_only_one_cell_per_location
    cell1 = LiveCell.at(0, 0)
    @world.add_cell(cell1)
    cell2 = LiveCell.at(0, 0)
    @world.add_cell(cell2)
    assert_equal(1, @world.cell_count)
  end

  def test_locations_can_be_compared
    @loc1 = Location.new(0,0)
    @loc2 = Location.new(0,0)
    assert_equal(@loc1, @loc2)
  end

  def test_world_knows_neighborhoods
    cell = LiveCell.at(0, 0)
    refute_nil(@world.neighborhood_of(cell.location))
  end

  def test_world_can_count_live_neighbors
    cell = LiveCell.at(0, 0)
    @world.add_cell(cell)
    @world.add_cell(LiveCell.at(0, 2))
    assert_equal(@world.count_neighbors_of(cell), 0)
    @world.add_cell(LiveCell.at(0, 1))
    assert_equal(@world.count_neighbors_of(cell), 1)
  end

  def test_world_knows_candidate_locations
    cell = LiveCell.at(0, 0)
    @world.add_cell(cell)
    candidates = @world.candidate_locations
    expected = @world.neighborhood_of(cell.location) + [cell.location]
    assert_equal(candidates, expected)
  end

  def test_empty_world_stays_empty
    assert_equal(@world.tick.cell_count, 0)
  end
end
