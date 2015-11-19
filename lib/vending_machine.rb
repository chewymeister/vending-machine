Delivery = Struct.new(:product, :change)

class VendingMachine
  def initialize inventory, change_calculator, till
    @change_calculator = change_calculator
    @till = till
    @inventory = inventory
    @balance = 0
    @chosen_item = :empty
    copy_stock_from_inventory!
  end

  def insert_money! amount
    @balance += amount 
  end

  def choose_item! product_name
    @chosen_item = @stock.find do |item|
      item[:product] == product_name
    end
  end

  def deliver!
    if insufficient_stock?
      Delivery.new("We do not have this item in stock, please choose another item", 0.00)
    elsif insufficient_funds?
      Delivery.new("Insufficient funds!", 0.00)
    elsif insufficient_change?
      change = @balance
      @balance = 0
      Delivery.new("We do not have change, please insert the exact amount", change)
    else
      checkout_purchase!
      Delivery.new(@chosen_item[:product], @change)
    end
  end

  def reload_coins!
    @till.reload_coins!
  end

  def reload_stock!
    copy_stock_from_inventory!
    choose_item! @chosen_item[:product]
  end

  def copy_stock_from_inventory!
    @stock = Marshal.load(Marshal.dump(@inventory))
  end

  private

  def insufficient_funds?
    @balance < @chosen_item[:price]
  end

  def insufficient_change?
    !@change_calculator.sufficient_coins?(@balance - @chosen_item[:price])
  end

  def insufficient_stock?
    @chosen_item[:stock] < 1
  end

  def checkout_purchase!
    @chosen_item[:stock] = @chosen_item[:stock] - 1 
    @change = @balance - @chosen_item[:price]
    @balance = 0
  end
end
