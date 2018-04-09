#!/usr/bin/env ruby

require 'terminfo'
require './lib/world.rb'
require './lib/ascii_display.rb'

coordinates = []
ARGF.each_line do |line|
  coordinates << line.split(',').map(&:to_i)
end
world = Conway::World.from_coordinate_list(coordinates)
count_log = []

def display(world, rows, columns, generation)
  display = Conway::AsciiDisplay.render(world, rows, columns)
  puts %x{clear}
  puts display
  puts "generation: #{generation} cell count: #{world.cell_count}"
end

begin
  loop do
    # allow resizing window
    rows, columns = TermInfo.screen_size
    display(world, rows-2, columns, count_log.count)
    sleep(0.1)
    count_log << world.cell_count
    world = world.tick
  end
rescue SystemExit, Interrupt
  display(world, rows-2, columns-1, count_log.count)
  puts "-" * columns
  puts "cells at time interrupted:"
  puts world.cells.map(&:location).sort.map(&:to_s).join("\n")
  puts "-" * columns
  puts "log of cell count:"
  puts count_log.each_with_index.map { |count, i| "#{i}: #{count}" }.join("\n")
end


