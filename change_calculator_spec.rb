# It should calculate how much change to give in the following scenarios
# £2, £1, 50p, 20p, 10p, 5p, 2p, 1p

require 'rspec'

class ChangeCalculator
  def initialize amount
    @amount = amount.round(2)
    @coin_map = {
      two_pound: 2.00,
      one_pound: 1.00,
      fifty_pee: 0.5,
      twenty_pee: 0.2,
      ten_pee: 0.1,
      five_pee: 0.05,
      two_pee: 0.02,
      one_pee: 0.01
    }
  end

  def change
    required_coins = Hash.new(0)

    @coin_map.each do |coin, value|
      value = value.round(2)
      while @amount >= value
        required_coins[coin] += 1
        @amount = (@amount - value).round(2)
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
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1 })
    end

    it "should require 2 two pound coins" do
      amount = 4.00
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 2 })
    end

    it "should require 2 two pound coins and 1 one pound coin" do
      amount = 5.00
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 2, one_pound: 1 })
    end

    it "should require 1 two pound, 1 one pound, and 1 fifty pee coin" do
      amount = 3.50
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1, fifty_pee: 1 })
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty pee coin" do
      amount = 3.70
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1,
                                     fifty_pee: 1, twenty_pee: 1})
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten pee coin" do
      amount = 3.80
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1,
                                     fifty_pee: 1, twenty_pee: 1, ten_pee: 1})
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five pee coin" do
      amount = 3.85
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1,
                                     fifty_pee: 1, twenty_pee: 1,
                                     ten_pee: 1, five_pee: 1})
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five, 1 two pee coin" do
      amount = 3.87
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1,
                                     fifty_pee: 1, twenty_pee: 1,
                                     ten_pee: 1, five_pee: 1, two_pee: 1})
    end
  end
end
