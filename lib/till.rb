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
    reload_coins!
  end

  def reload_coins!
    @stock = FULL_TILL.dup
  end

  def in_stock? coin
    @stock[coin] > 0
  end

  def dispense! coin
    @stock[coin] -= 1
  end
end
