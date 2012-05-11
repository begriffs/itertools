require 'itertools'
require 'spec_helper'

describe Itertools do
  context "#count" do
    context "step is a positive number" do
      it "counts up" do
        Itertools.count(3,1).should begin_with [3,4,5]
      end
    end
    context "step is zero" do
      it "step is zero" do
        Itertools.count(0,0).should begin_with [0]*100
      end
    end
    context "step is a negative number" do
      it "counts down" do
        Itertools.count(0,-1).should begin_with [0, -1, -2]
      end
    end
    context "step is unspecified" do
      it "counts by one" do
        Itertools.count(0).should begin_with [0,1,2]
      end
    end
  end

  context "#cycle" do
    context "with an array" do
      it "loops" do
        Itertools.cycle([0,1,2]).should begin_with [0,1,2,0,1,2,0,1,2]
      end
    end
    context "with a ruby string" do
      it "loops" do
        expected = ['w','h','o','o','l','w','h','o','o','l','w']
        subject.cycle('whool').should begin_with expected
      end
    end
  end

  describe "#repeat" do
    context "with a limit" do
      it "repeats the proper amount of times" do
        seq = Itertools.repeat(0,5)
        seq.should begin_with [0]*5
        seq.should be_exhausted
      end
    end
    context "zero limit" do
      it "yields nothing" do
        Itertools.repeat(0,0).should be_exhausted
      end
    end
    context "without a limit" do
      it "repeats endlessly" do
        Itertools.repeat(0).should begin_with [0]*100
      end
    end
  end
end
