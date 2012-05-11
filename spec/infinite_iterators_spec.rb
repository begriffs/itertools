require 'itertools'

describe Itertools do
  describe "#count" do
    context "step is a positive number" do
      it "counts up" do
        seq = Itertools.count(3,1)
        seq.resume.should == 3
        seq.resume.should == 4
        seq.resume.should == 5
      end
    end
    context "step is zero" do
      it "step is zero" do
        seq = Itertools.count(0,0)
        seq.resume.should == 0
        seq.resume.should == 0
        seq.resume.should == 0
      end
    end
    context "step is a negative number" do
      it "counts down" do
        seq = Itertools.count(0,-1)
        seq.resume.should == 0
        seq.resume.should == -1
        seq.resume.should == -2
      end
    end
    context "step is unspecified" do
      it "counts by one" do
        seq = Itertools.count(0)
        seq.resume.should == 0
        seq.resume.should == 1
        seq.resume.should == 2
      end
    end
  end


  describe "#cycle" do
    shared_examples "cycle" do
      it "loops" do
        cycle = Itertools.cycle(param)
        results.each do |result|
          cycle.resume.should == result
        end
      end
    end
    context "with an array" do
      let(:param) { [0,1,2] }
      let(:results) { [0,1,2,0,1,2,0,1,2] }
      it_behaves_like "cycle"
    end
    context "with a ruby string" do
      let(:param) { 'whool' }
      let(:results) { ['w','h','o','o','l','w','h','o','o','l','w']}
      it_behaves_like "cycle"
    end
  end
end
