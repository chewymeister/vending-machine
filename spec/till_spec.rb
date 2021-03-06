require 'rspec'
require_relative '../lib/till.rb'

describe Till do
  context "when coins are in stock" do
    it "should return true for two pound coin" do
      till = Till.new

      expect(till.in_stock?(:two_pound)).to be true
    end

    it "should return true for one pound coin" do
      till = Till.new

      expect(till.in_stock?(:one_pound)).to be true
    end

    it "should return true for fifty pee coin" do
      till = Till.new

      expect(till.in_stock?(:fifty_pee)).to be true
    end

    it "should return true for twenty pee coin" do
      till = Till.new

      expect(till.in_stock?(:twenty_pee)).to be true
    end

    it "should return true for ten pee coin" do
      till = Till.new

      expect(till.in_stock?(:ten_pee)).to be true
    end

    it "should return true for five pee coin" do
      till = Till.new

      expect(till.in_stock?(:five_pee)).to be true
    end

    it "should return true for two pee coin" do
      till = Till.new

      expect(till.in_stock?(:two_pee)).to be true
    end

    it "should return true for one pee coin" do
      till = Till.new

      expect(till.in_stock?(:one_pee)).to be true
    end
  end

  context "when coins are not in stock" do
    let(:till) { Till.new }
    before do
      10.times do |n|
        till.dispense!(:two_pound)
      end
    end

    it "should return false for two pound coin" do
      expect(till.in_stock?(:two_pound)).to be false
    end

    it "should return true for two pound coin when coins are reloaded" do
      expect{till.reload_coins!}.to change{till.in_stock?(:two_pound)}
        .from(false).to(true)
    end
  end
end
