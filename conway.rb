#!/usr/bin/env ruby

require 'terminfo'
require './lib/world.rb'
require './lib/ascii_display.rb'

coordinates = []
ARGF.each_line do |line|
  coordinates << line.split(',').map(&:to_i)
end

world = Conway::World.from_coordinate_list(coordinates)
generation = 0

begin
  loop do
    rows, columns = TermInfo.screen_size
    display = Conway::AsciiDisplay.render(world, rows-2, columns-1)
    puts %x{clear}
    puts display
    puts "generation #{generation}"
    sleep(0.1)
    generation += 1
    world = world.tick
  end
rescue SystemExit, Interrupt
  puts %x{clear}
  puts display
  puts world.cells.map(&:location).sort.map(&:to_s).join("\n")
end


