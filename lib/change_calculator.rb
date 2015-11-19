class ChangeCalculator
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

  def dispense_change! amount
    calculate_change_with @till, amount
  end

  def sufficient_coins? amount
    try_to_change amount
    all_change_dispensed?
  end

  private

  def try_to_change amount
    till = @till.clone
    calculate_change_with till, amount
  end

  def calculate_change_with till, amount
    @balance = amount
    COIN_MAP.each do |coin, value|
      return if all_change_dispensed?
      next if out_of_stock? till, coin

      while @balance >= value
        till.dispense!(coin)
        @balance = (@balance - value).round(2)
      end
    end
  end

  def out_of_stock? till, coin
    !till.in_stock?(coin)
  end

  def all_change_dispensed?
    @balance == 0.0
  end
end
