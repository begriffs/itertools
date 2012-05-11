require "itertools/version"

module Itertools
  class << self
    def count(start, step = 1)
      return Fiber.new do
        while true
          Fiber.yield start
          start += step
        end
      end
    end

    def cycle(wheel)
      return Fiber.new do
        spoke = 0
        while true
          Fiber.yield wheel[spoke]
          spoke = (spoke + 1) % wheel.length
        end
      end
    end
  end
end
