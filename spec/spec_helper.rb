RSpec::Matchers.define :begin_with do |expected|
  match do |fiber|
    @i, @seen = 0, nil
    for e in expected
      @seen = fiber.resume
      @seen.should == e
      @i += 1
    end
  end

  failure_message_for_should do |fiber|
    "Expected '#{expected[@i]}' at position #{@i+1}, but found '#{@seen}'"
  end
end

RSpec::Matchers.define :be_exhausted do
  match do |fiber|
    @seen = nil
    lambda {@seen = fiber.resume}.should raise_error(StopIteration)
  end

  failure_message_for_should do |fiber|
    "Expected sequence to be exhausted, but read '#{@seen}'"
  end
end
