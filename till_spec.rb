require 'rspec'

class Till
  FULL_TILL = {
    two_pound: 10,
    one_pound: 10,
    fifty_pee: 10,
    twenty_pee: 10,
    ten_pee: 10,
    five_pee: 10,
    two_pee: 10,
    one_pee: 10
  }

  def initialize
    @stock = FULL_TILL.dup
  end

  def in_stock? coin
    @stock[coin] > 0
  end

  def dispense! coin
    @stock[coin] -= 1
  end
end

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
    it "should return false for two pound coin" do
      till = Till.new
      10.times do |n|
        till.dispense!(:two_pound)
      end

      expect(till.in_stock?(:two_pound)).to be false
    end
  end
end
