#!/usr/bin/env ruby

require './lib/world.rb'
require './lib/ascii_display.rb'

world = Conway::World.from_coordinate_list(
  [ [0, 1],
    [1, 0],
    [-1, -1],
    [0, -1],
    [1, -1],
  ])


loop do
  puts %x{clear}
  puts Conway::AsciiDisplay.render(world, 79, 39)
  sleep(0.1)
  world = world.tick
end

