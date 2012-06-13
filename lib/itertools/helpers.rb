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
    def array fiber
      result = []
      loop { result << fiber.resume }
      result
    end
  end
end
