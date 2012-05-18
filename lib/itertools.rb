require "itertools/version"
require "itertools/infinite_iterators"
require "itertools/terminating_iterators"
require "fiber"

module Itertools
  class << self
    include InfiniteIterators
    include TerminatingIterators
    def forever
      Fiber.new do
        while true
          yield
        end
      end
    end
  end
end
