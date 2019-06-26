# Right now only handles wholesale discounts

class ClearanceDiscountedPriceGenerator
  CLEARANCE_PRICE_PERCENTAGE  = BigDecimal.new("0.75")

  WHOLESALE_DISCOUNT_LIMITS = {
    'FIVEDOLLAR' => 5,
     'TWODOLLAR' => 2,
  }.freeze

  # Discount codes
  WHOLESALE_DISCOUNT_CODES = {
    'FIVEDOLLAR' => %w(Pants Dress).freeze,
     'TWODOLLAR' => %w(Sweater Top Scarf).freeze
  }.freeze

  def initialize(item)
    @item = item
  end

  def generate_discount
    discounted_price_by_code
  end

  private

  # Limit discount
  def discounted_price_by_code
    discounted_price < discount_limit ? discount_limit : discounted_price
  end

  def discounted_price
    @discounted_price ||= @item.style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
  end

  def discount_code
    WHOLESALE_DISCOUNT_CODES.select { |k, v| v.include?(@item.style.type) }.keys.first 
  end

  def discount_limit
    @discount_limit ||= WHOLESALE_DISCOUNT_LIMITS[discount_code]
  end
end