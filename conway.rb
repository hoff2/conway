#!/usr/bin/env ruby

require 'terminfo'

require './lib/world.rb'
require './lib/ascii_display.rb'

coordinates = []
ARGF.each_line do |line|
  coordinates << line.split(',').map(&:to_i)
end

world = Conway::World.from_coordinate_list(coordinates)

loop do
  rows, columns = TermInfo.screen_size
  puts %x{clear}
  puts Conway::AsciiDisplay.render(world, rows-1, columns-1)
  sleep(0.1)
  world = world.tick
end


