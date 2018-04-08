#!/usr/bin/env ruby

require 'terminfo'

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
  rows, columns = TermInfo.screen_size
  puts %x{clear}
  puts Conway::AsciiDisplay.render(world, rows-1, columns-1)
  sleep(0.1)
  world = world.tick
end


