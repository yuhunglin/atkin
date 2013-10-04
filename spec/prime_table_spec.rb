require 'spec_helper'
require 'Prime'
require 'Matrix'
require_relative '../prime_table'

describe PrimeTable do
  let(:std_11x11) { std_table(10) }
  let(:std_101x101) { std_table(100) }

  context "#print_table_interals 11x11" do
    subject { Matrix[*described_class.new.print_table_internals(10)] }

    it { subject.should be_square }
    it { subject.should eq(std_11x11) }
    it { subject.transpose.should eq(std_11x11) }
  end

  context "#print_table_interals 101x101" do
    subject { Matrix[*described_class.new.print_table_internals(100)] }

    it { subject.should be_square }
    it { subject.should eq(std_101x101) }
    it { subject.transpose.should eq(std_101x101) }
  end

  context "#print_table" do
    let(:tab_delimited_11x11) { tab_delimited_table(10) }

    subject { capture_stdout { described_class.new.print_table } }

    it "tab-delimited 11x11 table" do
      subject.string.should eq(tab_delimited_11x11)
    end
    it { subject.string.split(/\n/).length.should eq(11) }
    it { subject.string.split(/\n/).all? {|row| row.split(/\t/).length == 11 }.should be_true}

    context "bad inputs" do
      it { capture_stdout { described_class.new.print_table('foo') }.string.should eq("") }
      it { capture_stdout { described_class.new.print_table(-1) }.string.should eq("") }
      it { capture_stdout { described_class.new.print_table(3.1415) }.string.should eq("") }
    end
  end

  def tab_delimited_table(size)
    std_table(size).to_a.map{ |row| row.join("\t") }.join("\n") + "\n"
  end

  def std_table(size)
    identity_row = Prime.first(size)
    identity_row.unshift(1)
    result = identity_row.enum_for.map do |column|
      identity_row.enum_for.map { |row| row * column }
    end
    Matrix[*result]
  end

  # Being somewhat evil and messing with the Kernel to snatch stdout without more libraries
  module Kernel
    def capture_stdout
      out = StringIO.new
      $stdout = out
      yield
      return out
    ensure
      $stdout = STDOUT
    end
  end
end