module Conway
  module AsciiDisplay
    def self.render(world, rows, columns)
      max_x = (columns / 2).floor
      min_x = max_x - columns + 1
      max_y = (rows / 2).floor
      min_y = max_y - rows + 1
      (min_y..max_y).map{ |y|
        (min_x..max_x).map{ |x|
          if world.has_cell_at?(Location.new(x, y))
            '@'
          else
            ' '
          end
        }.join
      }.join("\n")
    end
  end
end
