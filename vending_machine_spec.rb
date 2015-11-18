# Programming Exercise: Vending Machine Exercise
# Design a vending machine using a programming language of your choice. The vending machine should perform as follows:
#   
#   Once an item is selected and the appropriate amount of money is inserted, the vending machine should return the correct product.
#   It should also return change if too much money is provided, or ask for more money if insufficient funds have been inserted.
#   The machine should take an initial load of products and change. The change will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2.
#   There should be a way of reloading either products or change at a later point.
#   The machine should keep track of the products and change that it contains.a

require 'rspec'

Delivery = Struct.new(:product, :change)

class Vendor
  def initialize inventory
    @inventory = inventory
    @balance = 0
    @chosen_item = :empty
  end

  def insert_money! amount
    @balance += amount 
  end

  def choose_item! product_name
    @chosen_item = @inventory.find do |item|
      item[:product] == product_name
    end
  end

  def purchase_is_valid?
    @balance >= @chosen_item[:price]
  end

  def checkout_purchase!
    @chosen_item[:stock] = @chosen_item[:stock] - 1 
    @balance -= @chosen_item[:price]
  end

  def deliver!
    if purchase_is_valid?
      checkout_purchase!
      Delivery.new(@chosen_item[:product], @balance)
    else
      Delivery.new("Insufficient funds!", @balance)
    end
  end
end

describe Vendor do
  let(:inventory) {[
    {product: 'Coke', price: 1.00, stock: 5},
    {product: 'Mars Bar', price: 0.50, stock: 10},
    {product: 'Sprite', price: 1.20, stock: 8}
  ]}

  let(:vendor) { Vendor.new(inventory) }

  context "when an item is selected" do
    context "and the correct amount of money has been inserted" do
      before do
        vendor.insert_money!(1.00)
        vendor.choose_item!("Coke")
      end

      it "the vending machine should return the correct product" do
        delivery = vendor.deliver!

        expect(delivery.product).to eq "Coke"
      end
    end

    context "and an insufficient amount of money has been inserted" do
      before do
        vendor.insert_money!(0.50)
        vendor.choose_item!("Coke")
      end

      it "the vending machine should return an error message" do
        delivery = vendor.deliver!

        expect(delivery.product).to eq "Insufficient funds!"
      end

      it "and should return the product once sufficient funds have been inserted" do
        expect{vendor.insert_money!(0.50)}.to change{vendor.deliver!.product}
          .from("Insufficient funds!").to("Coke")
      end
    end
  end
end
