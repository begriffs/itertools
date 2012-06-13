require "itertools/version"
require "itertools/helpers"
require "itertools/infinite_iterators"
require "itertools/terminating_iterators"
require "itertools/combinatoric_generators"

module Itertools
  class << self
    include InfiniteIterators
    include TerminatingIterators
    include CombinatoricGenerators

    private
    include Helpers
  end
end
