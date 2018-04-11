require 'minitest/autorun'
require './lib/ascii_display.rb'
require './lib/world.rb'

class AsciiDisplayTest < Minitest::Test
  def test_display_of_a_small_world
    world = Conway::World.from_coordinate_list(
      [[0, -1], [0, 0], [0, 1]]
    )
    assert_equal(
      Conway::AsciiDisplay.render(world, 3, 3),
      " @ \n @ \n @ "
    )
  end
end
