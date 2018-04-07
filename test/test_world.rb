require 'minitest/autorun'
require 'minitest/spec'

require './lib/world.rb'

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
