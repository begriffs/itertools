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

  def begins(fiber, expected)
    for e in expected
      fiber.resume.should == e
    end
  end

  def ended(fiber)
    lambda {fiber.resume}.should raise_error
  end

  describe "#cycle" do
    let(:cycle) { Itertools.cycle(params) }
    context "with an array" do
      let(:params) { [0,1,2] }
      it "loops" do
        begins(cycle, [0,1,2,0,1,2,0,1,2])
      end
    end
    context "with a ruby string" do
      let(:params) { 'whool' }
      let(:results) { ['w','h','o','o','l','w','h','o','o','l','w']}
      it "loops" do
        begins(cycle, results)
      end
    end
  end

  describe "#repeat" do
    let(:repeat) { Itertools.repeat(*params) }
    context "with a limit" do
      let(:params) { [0, 5] }
      it "repeats the proper amount of times" do
        begins(repeat, [0] * 5)
        ended(repeat)
      end
    end
    context "zero limit" do
      let(:params) { [0, 0] }
      it "yields nothing" do
        ended(repeat)
      end
    end
    context "without a limit" do
      let(:params) { [0] }
      it "repeats endlessly" do
        begins(repeat, [0] * 100)
      end
    end
  end
end
