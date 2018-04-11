#!/usr/bin/env ruby

require './lib/world.rb'
require './lib/ascii_display.rb'

coordinates = []
ARGF.each_line do |line|
  coordinates << line.split(',').map(&:to_i)
end

world = Conway::World.from_coordinate_list(coordinates)
count_log = []
begin
  loop do
    Conway::Terminal.display(world, count_log.count)
    sleep(0.1)
    count_log << world.cell_count
    world = world.tick
  end
rescue SystemExit, Interrupt
  Conway::Terminal.display(world, count_log.count)
  puts '---'
  puts 'cells at time interrupted:'
  puts world.cells.map(&:location).sort.map(&:to_s).join("\n")
  puts '---'
  puts 'log of cell count:'
  puts count_log.each_with_index.map { |count, i| "#{i}: #{count}" }.join("\n")
end
