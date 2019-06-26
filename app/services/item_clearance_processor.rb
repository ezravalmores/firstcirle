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
    item.price_sold = discounted_price 
    item.sold_at = Time.now

    # Set batch id if Clearanced from batch service
    item.clearance_batch_id = @batch_id if @batch_id.present?

    item.save!
  end

  def discounted_price 
    ClearanceDiscountedPriceGenerator.new(item).generate_discount
  end
end