class ItemClearanceProcessor
  Error = Class.new(StandardError)

  # Read/Write
  attr_accessor :item

  def initialize(item, batch_id=nil)
    @item = item
    @batch_id = batch_id
  end

  def run!
    clearance_and_save!
  end

  private

  def clearance_and_save!
    item.set_status_to_clearanced
    item.price_sold = discount.last_discounted_price
    item.discounted_price = discount.discounted_price
    item.last_discounted_price = discount.last_discounted_price
    item.discount_limit_given = discount.discount_limit_given?
    item.sold_at = Time.now

    # Set batch id if clearance batch process id was passed
    item.clearance_batch_id = @batch_id if @batch_id.present?

    item.save!
  end

  def discount
    @discount ||= ClearanceDiscountedPriceGenerator.new(item)
  end
end