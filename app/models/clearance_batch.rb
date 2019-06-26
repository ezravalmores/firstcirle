class ClearanceBatch < ApplicationRecord
  has_many :items

  def total_price_sold
    items.sum(:price_sold)
  end
end
