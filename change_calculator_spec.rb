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
    @amount = amount.round(2)
    COIN_MAP.each do |coin, value|
      return if @amount == 0.00
      next if !@till.in_stock?(coin)

      value = value.round(2)
      while @amount >= value
        @till.dispense!(coin)
        @amount = (@amount - value).round(2)
      end
    end
  end

  def sufficient_coins?
    @amount == 0
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
      full_coins_for till

      expect(till).to receive(:dispense!).with(:two_pound).twice
      expect(till).to receive(:dispense!).with(:one_pound).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, and 1 fifty pee coin" do
      amount = 3.50
      till = double("till")
      full_coins_for till
      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:one_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end

    it "should require 1 two pound, 1 one pound, 1 fifty, 1 twenty pee coin" do
      amount = 3.70
      till = double("till")
      full_coins_for till

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
      full_coins_for till

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
      full_coins_for till

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
      full_coins_for till 

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
      full_coins_for till 

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
      full_coins_for till

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

  context "Examples for when there isn't sufficient amounts of one coin" do
    it "should require 1 two pound, 3 fifty, 1 twenty, 1 ten, 1 five, 1 two and 1 one pee coin" do
      amount = 3.88
      till = double("till")
      out_of_coins_for till, :one_pound

      expect(till).to receive(:dispense!).with(:two_pound).once
      expect(till).to receive(:dispense!).with(:fifty_pee).exactly(3).times
      expect(till).to receive(:dispense!).with(:twenty_pee).once
      expect(till).to receive(:dispense!).with(:ten_pee).once
      expect(till).to receive(:dispense!).with(:five_pee).once
      expect(till).to receive(:dispense!).with(:two_pee).once
      expect(till).to receive(:dispense!).with(:one_pee).once

      calculator = ChangeCalculator.new(till)
      calculator.change amount
    end
  end

  context "#sufficient_coins?" do
    context "when there is sufficient change" do
      it "should return true" do
        amount = 2.00
        till = double("till")
        allow(till).to receive(:in_stock?).with(:two_pound).and_return(true).once
        allow(till).to receive(:dispense!).with(:two_pound).once

        calculator = ChangeCalculator.new(till)
        calculator.change amount
        expect(calculator.sufficient_coins?).to be true
      end
    end

    context "when there isn't sufficient change" do
      it "should indicate that there isn't enough change" do
        amount = 3.88
        till = double("till")
        out_of_all_coins till

        calculator = ChangeCalculator.new(till)
        calculator.change amount
        expect(calculator.sufficient_coins?).to be false
      end

      it "should indicate that there isn't enough change" do
        amount = 2.00
        till = double("till")
        out_of_all_but_one_coin till, :one_pound
        allow(till).to receive(:dispense!).with(:one_pound).once

        calculator = ChangeCalculator.new(till)
        calculator.change amount
        expect(calculator.sufficient_coins?).to be false
      end
    end
  end
end

def full_coins_for till
  coins = ChangeCalculator::COIN_MAP.keys
  coins.each do |coin|
    allow(till).to receive(:in_stock?).with(coin).and_return(true)
  end
end

def out_of_coins_for till, exception
  coins = ChangeCalculator::COIN_MAP.keys
  coins.each do |coin|
    unless coin == exception
      allow(till).to receive(:in_stock?).with(coin).and_return(true)
    end
  end

  allow(till).to receive(:in_stock?).with(exception).and_return(false)
end

def out_of_all_coins till
  coins = ChangeCalculator::COIN_MAP.keys
  coins.each do |coin|
    allow(till).to receive(:in_stock?).with(coin).and_return(false)
  end
end

def out_of_all_but_one_coin till, only_coin
  coins = ChangeCalculator::COIN_MAP.keys
  coins.each do |coin|
    unless coin == only_coin
      allow(till).to receive(:in_stock?).with(coin).and_return(false)
    end
  end

  allow(till).to receive(:in_stock?).with(only_coin).and_return(true).once
  allow(till).to receive(:in_stock?).with(only_coin).and_return(false).once
end
