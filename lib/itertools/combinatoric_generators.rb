module Itertools
  module CombinatoricGenerators

    def product *iters
      pools  = iters.map { |i| Itertools.array i }
      p      = pools.shift || []
      Itertools.iter p.product *pools
    end

  end
end
