require 'itertools'

describe Itertools do
  describe "#chain" do
    context "given finite inputs" do
      it "connects them" do
        a = Itertools.repeat(0, 2)
        b = Itertools.repeat(1, 2)
        c = Itertools.repeat(2, 2)
        seq = Itertools.chain(a, b, c)
        seq.should begin_with [0,0,1,1,2,2]
        seq.should be_exhausted
      end
      it "handles exhausted inputs" do
        a   = Itertools.repeat(0, 0)
        b   = Itertools.repeat(1, 1)
        seq = Itertools.chain(a, b)
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
end
