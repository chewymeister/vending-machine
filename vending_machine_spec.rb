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
  def initialize inventory, change_calculator, till
    @change_calculator = change_calculator
    @till = till
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

  def insufficient_funds?
    @balance < @chosen_item[:price]
  end

  def insufficient_change?
    !@change_calculator.sufficient_funds?(@balance - @chosen_item[:price])
  end

  def insufficient_stock?
    @chosen_item[:stock] < 1
  end

  def checkout_purchase!
    @chosen_item[:stock] = @chosen_item[:stock] - 1 
    @change = @balance - @chosen_item[:price]
    @balance = 0
  end

  def deliver!
    if insufficient_stock?
      Delivery.new("We do not have this item in stock, please choose another item", 0.00)
    elsif insufficient_funds?
      Delivery.new("Insufficient funds!", 0.00)
    elsif insufficient_change?
      change = @balance
      balance = 0
      Delivery.new("We do not have change, please insert the exact amount", change)
    else
      checkout_purchase!
      Delivery.new(@chosen_item[:product], @change)
    end
  end
end

describe Vendor do
  let(:inventory) {[
    {product: 'Coke', price: 1.00, stock: 5},
    {product: 'Mars Bar', price: 0.50, stock: 10},
    {product: 'Sprite', price: 1.20, stock: 8}
  ]}
  let(:till) { double("till") }
  let(:change_calculator) { double("change_calculator") }
  before do
    allow(change_calculator).to receive(:sufficient_funds?).and_return(true)
  end

  let(:vendor) { Vendor.new(inventory, change_calculator, till) }

  context "when an item is selected" do
    context "and the correct amount of money has been inserted" do
      let(:delivery) { vendor.deliver! }
      before do
        vendor.choose_item!("Coke")
        vendor.insert_money!(1.00)
      end

      it "the vending machine should return the correct product" do
        expect(delivery.product).to eq "Coke"
      end

      it "the vending machine should return no change" do
        expect(delivery.change).to eq 0.00
      end
    end

    context "and too much money has been inserted" do
      let(:delivery) { vendor.deliver! }
      before do
        vendor.choose_item!("Coke")
        vendor.insert_money!(2.00)
      end

      it "the vending machine should return the correct product" do
        expect(delivery.product).to eq "Coke"
      end

      it "the vending machine should return 1.00 in change" do
        expect(delivery.change).to eq 1.00
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

      it "the vending machine should return the product once sufficient funds have been inserted" do
        expect{vendor.insert_money!(0.50)}.to change{vendor.deliver!.product}
          .from("Insufficient funds!").to("Coke")
      end
    end

    context "when there aren't enough coins to return the correct change" do
      let(:original_amount) { 2.00 }
      before do
        vendor.insert_money!(original_amount)
        vendor.choose_item!("Coke")
      end

      it "the vending machine should return the 'we do not have change' error message" do
        allow(change_calculator).to receive(:sufficient_funds?).and_return(false)
        delivery = vendor.deliver!

        expect(delivery.product).to eq "We do not have change, please insert the exact amount"
      end

      it "the vending machine should return the original amount inserted" do
        allow(change_calculator).to receive(:sufficient_funds?).and_return(false)
        delivery = vendor.deliver!

        expect(delivery.change).to eq original_amount
      end

      it "the vending machine should not have any funds remaining in the balance" do
        allow(change_calculator).to receive(:sufficient_funds?).and_return(false)
        delivery = vendor.deliver!

        expect(delivery.change).to eq original_amount
      end
    end

    context "when there isn't enough stock" do
      before do
        10.times do |n|
          vendor.insert_money!(2.00)
          vendor.choose_item!("Coke")
          vendor.deliver!
        end
      end

      it "the vending machine should return an error message" do
        delivery = vendor.deliver!

        expect(delivery.product).to eq "We do not have this item in stock, please choose another item"
      end

      it "the vending machine should not return the balance" do
        delivery = vendor.deliver!

        expect(delivery.change).to eq 0.00
      end
    end
  end
end
