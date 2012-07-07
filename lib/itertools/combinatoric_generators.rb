module Itertools
  module CombinatoricGenerators

    def product *iters
      pools  = iters.map { |i| Itertools.array i }
      p      = pools.shift || []
      Itertools.iter p.product *pools
    end

    def permutations iter, r=nil
      Fiber.new do
        pool    = array Itertools.iter(iter)
        n       = pool.length
        r     ||= n
        indices = (0...n).to_a
        cycles  = ((n-r+1)..n).to_a.reverse
        exhausted if n == 0

        Fiber.yield indices.slice(0,r).map { |i| pool[i] }
        while true
          finished = true
          (r-1).downto(0) do |i|
            cycles[i] -= 1
            if cycles[i] == 0
              indices = indices.slice(0,i) + indices.slice(i+1,n) + [indices[i]]
              cycles[i] = n - i
            else
              j = cycles[i]
              indices[i], indices[-j] = indices[-j], indices[i]
              Fiber.yield indices.slice(0,r).map { |i| pool[i] }
              finished = false
              break
            end
          end
          exhausted if finished
        end
      end
    end

  end
end
