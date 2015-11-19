# It should calculate how much change to give in the following scenarios
# £2, £1, 50p, 20p, 10p, 5p, 2p, 1p

require 'rspec'

class ChangeCalculator
  attr_reader :coin_map
  COIN_MAP = {
    two_pound: 2.00,
    one_pound: 1.00,
    fifty_pee: 0.5,
    twenty_pee: 0.2,
    ten_pee: 0.1,
    five_pee: 0.05,
    two_pee: 0.02,
    one_pee: 0.01
  }


  def initialize till
    @till = till
  end

  def change amount
    required_coins = Hash.new(0)

    amount = amount.round(2)
    COIN_MAP.each do |coin, value|
      return required_coins if amount == 0.00
      next if !@till.in_stock?(coin)

      value = value.round(2)
      while amount >= value
        @till.dispense!(coin)
        amount = (amount - value).round(2)
      end
    end

    required_coins
  end
end

describe ChangeCalculator do
  context "Examples for when there is sufficient change" do
    it "should require 1 two pound coin" do
      amount = 2.00
      till = double("till")
      allow(till).to receive(:in_stock?).with(:two_pound).and_return(true).once

      expect(till).to receive(:dispense!).with(:two_pound).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 2 two pound coins" do
      amount = 4.00
      till = double("till")
      allow(till).to receive(:in_stock?).with(:two_pound).and_return(true)

      expect(till).to receive(:dispense!).with(:two_pound).twice

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 2 two pound coins and 1 one pound coin" do
      amount = 5.00
      till = double("till")
      full_stock_for till

      expect(till).to receive(:dispense!).with(:two_pound).twice
      expect(till).to receive(:dispense!).with(:one_pound).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, and 1 fifty pee coin" do
      amount = 3.50
      till = double("till")
      full_stock_for till
      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty pee coin" do
      amount = 3.70
      till = double("till")
      full_stock_for till

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten pee coin" do
      amount = 3.80
      till = double("till")
      full_stock_for till

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).once
      expect(till).to receive(:dispense!).with(:ten_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five pee coin" do
      amount = 3.85
      till = double("till")
      full_stock_for till

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).once
      expect(till).to receive(:dispense!).with(:ten_pee).once
      expect(till).to receive(:dispense!).with(:five_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five, 1 two pee coin" do
      amount = 3.87
      till = double("till")
      full_stock_for till 

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).once
      expect(till).to receive(:dispense!).with(:ten_pee).once
      expect(till).to receive(:dispense!).with(:five_pee).once
      expect(till).to receive(:dispense!).with(:two_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five, 1 two and 1 one pee coin" do
      amount = 3.88
      till = double("till")
      full_stock_for till 

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).once
      expect(till).to receive(:dispense!).with(:ten_pee).once
      expect(till).to receive(:dispense!).with(:five_pee).once
      expect(till).to receive(:dispense!).with(:two_pee).once
      expect(till).to receive(:dispense!).with(:one_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 3 two pound, 1 one pound, 1 fifty, 2 twenty, 1 five, and 2 two pee coins" do
      amount = 7.99
      till = double("till")
      full_stock_for till

      expect(till).to receive(:dispense!).with(:two_pound).exactly(3).times
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once
      expect(till).to receive(:dispense!).with(:twenty_pee).twice
      expect(till).to receive(:dispense!).with(:five_pee).once
      expect(till).to receive(:dispense!).with(:two_pee).twice

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end
  end

  context "Examples for when there isn't sufficient change" do
    xit "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty, 1 ten, 1 five, 1 two and 1 one pee coin" do
      amount = 3.88
      calculator = ChangeCalculator.new(amount)
      required_coins = calculator.change
      expect(required_coins).to eq({ two_pound: 1, one_pound: 1,
                                     fifty_pee: 1, twenty_pee: 1,
                                     ten_pee: 1, five_pee: 1,
                                     two_pee: 1, one_pee: 1})
    end
  end
end

def full_stock_for till
  allow(till).to receive(:in_stock?).with(:two_pound).and_return(true)
  allow(till).to receive(:in_stock?).with(:one_pound).and_return(true)
  allow(till).to receive(:in_stock?).with(:fifty_pee).and_return(true)
  allow(till).to receive(:in_stock?).with(:twenty_pee).and_return(true)
  allow(till).to receive(:in_stock?).with(:ten_pee).and_return(true)
  allow(till).to receive(:in_stock?).with(:five_pee).and_return(true)
  allow(till).to receive(:in_stock?).with(:two_pee).and_return(true)
  allow(till).to receive(:in_stock?).with(:one_pee).and_return(true)
end
