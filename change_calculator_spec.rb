# It should calculate how much change to give in the following scenarios
# £2, £1, 50p, 20p, 10p, 5p, 2p, 1p
# Test that when you validate change amount, you are not affecting the till, and when you give change, that you do affect the till balance
require 'rspec'

class ChangeCalculator
  def initialize amount
    @amount = amount
  end

  def change amount
    { two_pound: 1 }
  end
end

describe ChangeCalculator do
  context "Examples for when there is sufficient change" do
    it "should require 1 two pound coin" do
      amount = 2.00
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change 2.00
      expect(required_coins).to eq({ two_pound: 1 })
    end
  end
end
