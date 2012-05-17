require "itertools/version"
require "fiber"

module Itertools
  class << self
    def count start, step = 1
      Fiber.new do
        while true
          Fiber.yield start
          start += step
        end
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

    def chain *fibers
      Fiber.new do
        for f in fibers
          begin
            loop { Fiber.yield f.resume }
          rescue StopIteration
          end
        end
        raise StopIteration
      end
    end

    def compress seq, mask
      Fiber.new do
        while true
          s, m = seq.resume, mask.resume
          Fiber.yield s if m == 1
        end
      end
    end

    def dropwhile pred, seq
      Fiber.new do
        while true
          x = seq.resume
          if !(pred.call x)
            Fiber.yield x
            break
          end
        end
        loop { Fiber.yield seq.resume }
      end
    end

    def filterfalse pred, seq
      Fiber.new do
        while true
          s = seq.resume
          Fiber.yield s if !pred.call s
        end
      end
    end

  end
end
