require 'rails_helper'

describe ClearanceDiscountedPriceGenerator do 
  describe "#last_discounted_price" do
    let(:five_dollar_code) { 'FIVEDOLLAR' }
    let(:two_dollar_code) { 'TWODOLLAR' }

    context 'FIVEDOLLAR code items' do
      context 'discounted price is higher than the limit' do let(:pants_item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, type:'Pants', wholesale_price: 10)) }
        it 'should return return computed discounted price' do
          discount = ClearanceDiscountedPriceGenerator.new(pants_item)
          expect(discount.last_discounted_price).to eq(pants_item.style.wholesale_price * ClearanceDiscountedPriceGenerator::CLEARANCE_PRICE_PERCENTAGE)
        end
      end

      context 'discounted price is lower than the limit' do
        let(:pants_item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, type:'Pants', wholesale_price: 6.5)) }

        it 'should return return discount limit price' do
          discount = ClearanceDiscountedPriceGenerator.new(pants_item)
          expect(discount.last_discounted_price).to eq(ClearanceDiscountedPriceGenerator::WHOLESALE_DISCOUNT_LIMITS[five_dollar_code])
        end
      end
    end

    context 'TWODOLLAR code items' do
      context 'discounted price is higher than the limit' do let(:pants_item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, type:'Pants', wholesale_price: 10)) }
        it 'should return return computed discounted price' do
          discount = ClearanceDiscountedPriceGenerator.new(pants_item)
          expect(discount.last_discounted_price).to eq(pants_item.style.wholesale_price * ClearanceDiscountedPriceGenerator::CLEARANCE_PRICE_PERCENTAGE)
        end
      end

      context 'discounted price is lower than the limit' do
        let(:pants_item) { FactoryGirl.create(:item, style: FactoryGirl.create(:style, type:'Pants', wholesale_price: 6.5)) }

        it 'should return return discount limit price' do
          discount = ClearanceDiscountedPriceGenerator.new(pants_item)
          expect(discount.last_discounted_price).to eq(ClearanceDiscountedPriceGenerator::WHOLESALE_DISCOUNT_LIMITS[five_dollar_code])
        end
      end
    end
  end
end