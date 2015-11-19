# It should calculate how much change to give in the following scenarios
# £2, £1, 50p, 20p, 10p, 5p, 2p, 1p
# Test that when you validate change amount, you are not affecting the till, and when you give change, that you do affect the till balance
require 'rspec'

class ChangeCalculator
  def initialize amount
    @amount = amount
    @coin_map = {
      two_pound: 2.00,
      one_pound: 1.00,
      fifty_pee: 0.5,
      twenty_pee: 0.2,
      ten_pee: 0.1,
      five_pee: 0.05,
      one_pee: 0.01
    }
  end

  def change amount
    puts "Initial amount: #{amount}"
    required_coins = Hash.new(0)

    @coin_map.each do |coin, value|
      while amount >= value
        required_coins[coin] += 1
        amount -= value
      end
    end

    required_coins
  end
end

describe ChangeCalculator do
  context "Examples for when there is sufficient change" do
    it "should require 1 two pound coin" do
      amount = 2.00
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change amount
      expect(required_coins).to eq({ two_pound: 1 })
    end

    it "should require 2 two pound coins" do
      amount = 4.00
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change amount
      expect(required_coins).to eq({ two_pound: 2 })
    end
  end
end
