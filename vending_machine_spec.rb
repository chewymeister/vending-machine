# Programming Exercise: Vending Machine Exercise
# Design a vending machine using a programming language of your choice. The vending machine should perform as follows:
#   
#   Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
#   It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
#   The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
#   There should be a way of reloading either products or change at a later point.
#   The machine should keep track of the products and change that it contains.a

require 'rspec'
class Delivery
end

Delivery = Struct.new(:product, :change)

class Vendor
  attr_reader :balance

  def initialize inventory
    @inventory = inventory
    @balance = 0
  end

  def insert_money amount
    @balance += amount 
  end

  def select_item product
    chosen_item = @inventory.select do |item|
      item[:product] == product
    end.first

    chosen_item[:stock] = chosen_item[:stock] - 1 
    @balance -= chosen_item[:price]
    @delivery = Delivery.new(chosen_item[:product], @balance)
  end

  def deliver
    @delivery
  end
end

describe Vendor do
  context "Once an item is selected and the appropriate amount of money is inserted" do
    it "the vending machine should return the correct product" do
      inventory = [
        {product: 'Coke', price: 1.00, stock: 5},
        {product: 'Mars Bar', price: 0.50, stock: 10},
        {product: 'Sprite', price: 1.20, stock: 8}
      ]

      vendor = Vendor.new(inventory)
      vendor.insert_money(1.00)
      vendor.select_item("Coke")
      delivery = vendor.deliver

      expect(delivery.product).to eq "Coke"
      expect(delivery.change).to eq 0.00
    end
  end
end
