# Right now only handles wholesale discounts

class ClearanceDiscountedPriceGenerator
  CLEARANCE_PRICE_PERCENTAGE = BigDecimal.new("0.75")

  WHOLESALE_DISCOUNT_LIMITS = {
    'FIVEDOLLAR' => 5,
     'TWODOLLAR' => 2,
  }.freeze

  # Discount codes
  WHOLESALE_DISCOUNT_CODES = {
    'FIVEDOLLAR' => %w(pants dress).freeze,
     'TWODOLLAR' => %w(sweater top scarf).freeze
  }.freeze

  def initialize(item)
    @item = item
  end

  def last_discounted_price
    compute_last_discounted_price
  end

  def discounted_price
    compute_discounted_price
  end

  def discount_limit_given?
    discounted_price < discount_limit
  end

  private

  # Limit discount
  def compute_last_discounted_price
    @last_discounted_price ||= compute_discounted_price < discount_limit ? discount_limit : compute_discounted_price
  end

  def compute_discounted_price
    @discounted_price ||= @item.style.wholesale_price * CLEARANCE_PRICE_PERCENTAGE
  end

  def discount_limit
    @discount_limit ||= WHOLESALE_DISCOUNT_LIMITS[discount_code]
  end

  def discount_code
    WHOLESALE_DISCOUNT_CODES.select { |k, v| v.include?(@item.style.type.downcase) }.keys.first 
  end
end