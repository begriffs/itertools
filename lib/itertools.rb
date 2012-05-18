require "itertools/version"
require "itertools/helpers"
require "itertools/infinite_iterators"
require "itertools/terminating_iterators"

module Itertools
  class << self
    include InfiniteIterators
    include TerminatingIterators

    private
    include Helpers
  end
end
