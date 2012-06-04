module Itertools
  module TerminatingIterators

    def iter obj
      case obj
        when Fiber;  return obj
        when String; obj = obj.split //
      end
      Fiber.new do
        obj.each { |x| Fiber.yield x }
        exhausted
      end
    end

    def chain *fibers
      Fiber.new do
        for f in fibers
          loop { Fiber.yield f.resume }
        end
        exhausted
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

    def groupby seq, key = ->(x){x}
      seq = iter seq
      curr_val = group_val = nil
      forever do
        exhausted unless seq.alive? # in case a group fiber exhuasts seq
        while key.call(curr_val) == key.call(group_val) do
          curr_val = seq.resume
        end
        group_val = curr_val
        group = forever do
          Fiber.yield curr_val
          curr_val = seq.resume
          exhausted if key.call(curr_val) != key.call(group_val)
        end
        Fiber.yield [group_val, group]
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
        exhausted if stop and at >= stop
        Fiber.yield seq.resume
        (step - 1).times { seq.resume }
        at += step
      end
    end

    def starmap f, seq
      forever do
        Fiber.yield(f.call *seq.resume)
      end
    end

    def takewhile f, seq
      Fiber.new do
        x = seq.resume
        while f.call x
          Fiber.yield x
          x = seq.resume
        end
        exhausted
      end
    end

    def tee seq, n=2
      buffers = (0...n).map { [] } # [[]]*n makes shallow copies
      buffered_seq = ->(buf) do
        forever do
          if buf.empty?
            exhausted unless seq.alive? # seq previously exhausted
            fresh = seq.resume
            buffers.each { |b| b << fresh }
          end
          Fiber.yield buf.shift
        end
      end
      buffers.map { |b| buffered_seq.call b }
    end

  end
end
