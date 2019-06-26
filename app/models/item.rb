class Item < ApplicationRecord

  # Associations
  belongs_to :style
  belongs_to :clearance_batch

  # Statuses
  enum status: { 
    sellable: 'sellable', 
    not_sellable: 'not_sellable', 
    sold: 'sold', 
    clearanced: 'clearanced' 
  }

  # Queries
  scope :sellable, -> { where(status: 'sellable') }

  statuses.keys.each do |_status|
    # Setter.
    #
    #   item.status = nil
    #
    #   item.set_status_to_sellable
    #   item.status                  #=> "sellable"
    #
    #   item.set_status_to_failed
    #   item.status                  #=> "not_sellable"
    #
    #   item.set_status_to_sold
    #   item.status                  #=> "sold"
    #
    #   item.set_status_to_clearanced
    #   item.status                  #=> "clearanced"
    #
    self.send :define_method, "set_status_to_#{_status}", -> { self.status = _status }
  end

  def sellable?
    status == 'sellable'
  end
end
