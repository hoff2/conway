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

def display(world, rows, columns, generation)
  display = Conway::AsciiDisplay.render(world, rows, columns)
  puts %x{clear}
  puts display
  puts "generation: #{generation} cell count: #{world.cell_count}"
end

rows, columns = TermInfo.screen_size
begin
  loop do
    # uncomment to allow resizing window
    #rows, columns = TermInfo.screen_size
    display(world, rows-2, columns-1, generation)
    sleep(0.1)
    generation += 1
    world = world.tick
  end
rescue SystemExit, Interrupt
  display(world, rows-2, columns-1, generation)
  puts world.cells.values.map(&:location).sort.map(&:to_s).join("\n")
end


