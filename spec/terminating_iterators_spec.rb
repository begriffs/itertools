require 'itertools'

describe Itertools do
  describe "#iter" do
    it "converts strings" do
      seq = Itertools.iter "abcde"
      seq.should begin_with ['a', 'b', 'c', 'd', 'e']
      seq.should be_exhausted
    end
    it "converts arrays" do
      seq = Itertools.iter ['a', 'b', 'c', 'd', 'e']
      seq.should begin_with ['a', 'b', 'c', 'd', 'e']
      seq.should be_exhausted
    end
    it "leaves iterators unchanged" do
      seq = Itertools.iter Itertools.cycle [1,2,3]
      seq.should begin_with [1,2,3,1,2,3,1,2,3,1]
      seq.should_not be_exhausted
    end
    it "stays exhausted" do
      seq = Itertools.iter "a"
      seq.resume
      seq.should be_exhausted
      seq.should be_exhausted
    end
  end
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
  describe "#groupby" do
    context "given a ruby string" do
      it "generates proper keys" do
        seq = Itertools.groupby 'AAAABBBCCDAABBB'
        seq.resume[0].should == 'A'
        seq.resume[0].should == 'B'
        seq.resume[0].should == 'C'
        seq.resume[0].should == 'D'
        seq.resume[0].should == 'A'
        seq.resume[0].should == 'B'
        seq.should be_exhausted
      end
      it "generates proper values" do
        seq = Itertools.groupby 'AAAABBBCCD'
        v   = seq.resume[1]
        v.should begin_with ['A', 'A', 'A', 'A']
        v.should be_exhausted
        v   = seq.resume[1]
        v.should begin_with ['B', 'B', 'B']
        v.should be_exhausted
        v   = seq.resume[1]
        v.should begin_with ['C', 'C']
        v.should be_exhausted
        v   = seq.resume[1]
        v.should begin_with ['D']
        v.should be_exhausted
        seq.should be_exhausted
      end
    end
  end
  describe "#filterfalse" do
    it "filters properly" do
      nat  = Itertools.count 0
      pred = ->(x) { x%2 != 0 }
      seq  = Itertools.filterfalse pred, nat
      seq.should begin_with [0,2,4,6,8]
    end

    context "empty sequence" do
      it "does nothing" do
        empty = Itertools.repeat 0, 0
        (Itertools.filterfalse ->(x) {false}, empty).should be_exhausted
      end
    end
  end
  describe "#islice" do
    it "stops at the right place" do
      z   = Itertools.count 0
      seq = Itertools.islice z, 2
      seq.should begin_with [0,1]
      seq.should be_exhausted
    end

    it "starts and stops" do
      z   = Itertools.count 1
      seq = Itertools.islice z, 2, 4
      seq.should begin_with [3,4]
      seq.should be_exhausted
    end

    it "starts and keeps going" do
      z   = Itertools.count 1
      seq = Itertools.islice z, 2, nil
      seq.should begin_with [3,4,5,6,7]
      seq.should_not be_exhausted
    end

    it "starts and stops with step of 2" do
      z   = Itertools.count 1
      seq = Itertools.islice z, 2, 10, 2
      seq.should begin_with [3,5,7,9]
      seq.should be_exhausted
    end

    it "starts and stops with step of 7" do
      z   = Itertools.count 1
      seq = Itertools.islice z, 2, 40, 7
      seq.should begin_with [3,10,17,24,31,38]
      seq.should be_exhausted
    end
  end

end
