require 'spec_helper'
require 'Prime'
require 'benchmark'
require_relative '../atkin'

describe Atkin do
  context "#first" do
    context "default param" do
      it { described_class.new.first(0).should eq([]) }
    end
    context "pre-seeded entries contains results" do
      it { described_class.new.first(1).should eq([2]) }
      it { described_class.new.first(2).should eq([2, 3]) }
      it { described_class.new.first(3).should eq([2, 3, 5]) }
    end

    context "test against real Prime" do
      it { described_class.new.first(500).should eq(Prime.first(500)) }
    end

    context "start at non-zero lower bound" do
      let(:one_to_eleven_primes) do
        one_offset = Prime.first(11)
        one_offset.shift
        one_offset
      end

      it { described_class.new(3).first(10).should eq(one_to_eleven_primes) }
    end

    context "bad inputs" do
      it { expect { described_class.new.first(-1) }.to raise_error(ArgumentError) }
    end
  end
end