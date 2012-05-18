module Itertools
  module TerminatingIterators

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
      forever do
        s, m = seq.resume, mask.resume
        Fiber.yield s if m == 1
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
      forever do
        s = seq.resume
        Fiber.yield s if !pred.call s
      end
    end

    def islice seq, *args
      flip              = args.length > 1 ? 0 : 1
      start, stop, step = args[flip] || 0, args[1-flip], args[2] || 1
      (0...start).each { seq.resume }
      at = start
      forever do
        raise StopIteration if stop and at >= stop
        Fiber.yield seq.resume
        (step - 1).times { seq.resume }
        at += step
      end
    end

  end
end
