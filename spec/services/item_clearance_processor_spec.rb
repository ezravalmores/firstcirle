require 'rails_helper'

describe ItemClearanceProcessor do 
  describe "#run!" do
    let(:wholesale_price) { 100 }
    let(:item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, wholesale_price: wholesale_price)) }
    let(:discounted_price_generator) { instance_double(ClearanceDiscountedPriceGenerator) }
    let(:discounted_price) { BigDecimal.new(wholesale_price) * ClearanceDiscountedPriceGenerator::CLEARANCE_PRICE_PERCENTAGE }

    before do
      allow(ClearanceDiscountedPriceGenerator).to receive(:new).and_return(discounted_price_generator)
      allow(discounted_price_generator).to receive(:last_discounted_price).and_return(discounted_price)
      allow(discounted_price_generator).to receive(:discounted_price).and_return(10)
      allow(discounted_price_generator).to receive(:discount_limit_given?).and_return(false)
    end

    context "when clearance batch id is provided" do
      let(:clearance_batch) { FactoryGirl.create(:clearance_batch) }

      before do
        @item_clearance_processor = ItemClearanceProcessor.new(item, clearance_batch.id)
        @item_clearance_processor.run!
      end

      it "should mark the item status as clearanced" do
        expect(item.status).to eq(Item::statuses['clearanced'])
      end

      it "should set price sold" do
        expect(item.price_sold).to eq(discounted_price)
      end

      it "should set learance batch" do
        expect(item.clearance_batch_id).to eq(clearance_batch.id)
      end
    end

    context "when clearance batch id is not provided" do
      before do
        @item_clearance_processor = ItemClearanceProcessor.new(item)
        @item_clearance_processor.run!
      end

      it "should mark the item status as clearanced" do
        expect(item.status).to eq(Item::statuses['clearanced'])
      end

      it "should set price sold" do
        expect(item.price_sold).to eq(discounted_price)
      end

      it "should not set clearance batch" do
        expect(item.clearance_batch_id).to be_nil
      end
    end
  end
end
