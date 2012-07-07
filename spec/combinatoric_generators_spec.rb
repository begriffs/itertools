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
  context "#permutations" do
    context "with a string and a length" do
      it "permutes" do
        seq = Itertools.permutations "ABCD", 2
        seq.should begin_with [['A','B'], ['A','C'], ['A','D'], ['B','A'],
                               ['B','C'], ['B','D'], ['C','A'], ['C','B'],
                               ['C','D'], ['D','A'], ['D','B'], ['D','C']]
        seq.should be_exhausted
      end
    end
    context "with a string but no length" do
      it "defaults to the length of the string" do
        seq = Itertools.permutations "ABC"
        seq.should begin_with [['A','B','C'], ['A','C','B'], ['B','A','C'],
                               ['B','C','A'], ['C','A','B'], ['C','B','A']]
        seq.should be_exhausted
      end
    end
    context "with an empty array" do
      it "gives nothing" do
        Itertools.permutations([]).should be_exhausted
      end
    end
  end
end
