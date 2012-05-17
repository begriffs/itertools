require 'itertools'

describe Itertools do
  describe "#chain" do
    context "given finite inputs" do
      it "connects them" do
        a = Itertools.repeat 0, 2
        b = Itertools.repeat 1, 2
        c = Itertools.repeat 2, 2
        seq = Itertools.chain a, b, c
        seq.should begin_with [0,0,1,1,2,2]
        seq.should be_exhausted
      end
      it "handles exhausted inputs" do
        a   = Itertools.repeat 0, 0
        b   = Itertools.repeat 1, 1
        seq = Itertools.chain a, b
        seq.should begin_with [1]
        seq.should be_exhausted
      end
    end
    context "given no inputs" do
      it "fails gracefully" do
        seq = Itertools.chain
        seq.should be_exhausted
      end
    end
  end
  describe "#compress" do
    it "operates on infinite sequences" do
      all    = Itertools.count 0
      select = Itertools.cycle [1,0]
      Itertools.compress(all, select).should begin_with [0,2,4,6,8,10]
    end
    it "stops when mask runs out first" do
      nat   = Itertools.count 0
      empty = Itertools.repeat 1, 0
      seq   = Itertools.compress nat, empty
      seq.should be_exhausted
    end
    it "stops when data runs out first" do
      data = Itertools.repeat 'a', 3
      mask = Itertools.cycle [1]
      seq  = Itertools.compress data, mask
      seq.should begin_with ['a', 'a', 'a']
      seq.should be_exhausted
    end
  end
  describe "#dropwhile" do
    it "drops correctly" do
      data = Itertools.cycle [1,4,6,4,1]
      pred = ->(x) { x < 5 }
      seq  = Itertools.dropwhile pred, data
      seq.should begin_with [6,4,1]
    end
    it "produces nothing when appropriate" do
      data = Itertools.repeat 1, 10
      pred = ->(x) { true }
      seq  = Itertools.dropwhile pred, data
      seq.should be_exhausted
    end
  end
  describe "#filterfalse" do
    it "filters properly" do
      nat  = Itertools.count 0
      pred = ->(x) { x%2 != 0 }
      seq  = Itertools.filterfalse pred, nat
      seq.should begin_with [0,2,4,6,8]
    end
  end
end
