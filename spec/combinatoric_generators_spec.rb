require 'itertools'

describe Itertools do
  context "#product" do
    context "given two terminating iterators" do
      it "nests properly" do
        seq = Itertools.product (Itertools.iter 'ABC'), (Itertools.iter 'xy')
        seq.should begin_with [['A','x'],['A','y'], ['B','x'],['B','y'], ['C','x'],['C','y']]
        seq.should be_exhausted
      end
    end
    context "given no iterators" do
      it "gives nothing" do
        Itertools.product.should be_exhausted
      end
    end
  end
end
