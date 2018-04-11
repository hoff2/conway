require 'terminfo'

module Conway
  # turn a Conway::World into a string suitable for displaying on terminal
  module AsciiDisplay
    def self.render(world, rows, columns)
      max_x = (columns / 2).floor
      min_x = max_x - columns + 1
      max_y = (rows / 2).floor
      min_y = max_y - rows + 1
      (min_y..max_y).map { |y|
        (min_x..max_x).map { |x|
          if world.cell_at?(Location.new(x, y))
            '@'
          else
            ' '
          end
        }.join
      }.join("\n")
    end

    def self.display(world, generation)
      rows, columns = TermInfo.screen_size
      rendered = Conway::AsciiDisplay.render(world, rows - 2, columns)
      puts `%x(clear)`
      puts rendered
      puts "generation: #{generation} cell count: #{world.cell_count}"
    end
  end
end
