require "fiber"
module Itertools
  module Helpers
    def forever
      Fiber.new do
        while true
          yield
        end
      end
    end
    def exhausted
      raise StopIteration
    end
  end
end
