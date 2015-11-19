# make sure till keeps record of coins in stock
# test dispense! method
# test in_stock? method

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
    @stock = FULL_TILL.clone
  end

  def in_stock? coin
    @stock[coin] > 0
  end

  def dispense! coin
    @stock[coin] -= 1
  end
end

describe Till do
  context "#in_stock?" do
    context "when coins are in stock" do
      it "should return true for two pound coin" do
        till = Till.new
        expect(till.in_stock?(:two_pound)).to be true
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
end
