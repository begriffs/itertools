module Itertools
  module InfiniteIterators
    def count start, step = 1
      forever do
        Fiber.yield start
        start += step
      end
    end

    def cycle wheel
      Fiber.new do
        spoke = 0
        loop do
          Fiber.yield wheel[spoke]
          spoke = (spoke + 1) % wheel.length
        end
      end
    end

    def repeat element, count = -1
      Fiber.new do
        while count != 0
          Fiber.yield element
          count -= 1
        end
        raise StopIteration
      end
    end
  end
end
