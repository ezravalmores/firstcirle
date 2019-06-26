require 'csv'
require 'ostruct'
class ClearanceItemsFromCsvService

  Error = Class.new(StandardError)

  # Read/Write
  attr_accessor :batch, :errors, :items_clearanced_count

  def initialize(file)
    @batch = ClearanceBatch.new
    @errors = []
    @csv = CSV.read(file, headers: false)
    @row_position = 0
    @items_clearanced_count = 0
  end

  def process!
    transaction do
      run!
    end
  end

  private

  def run!
    # For the sake of documentation that a batch was ran
    # whether there are or there are no items that can be clearanced
    # Always persist the batch model.
    # I believe this is opinionated and must be dicided in the specs
    # but it was not mentioned so I just decided. :-)
    # Only process csv when batch is successfully created
    if @batch.save!

      # Process csv items
      @csv.each do |row|
        @row_position += 1
        item_id = row[0]

        if item_id_valid?(item_id)
          item = find_item(item_id)
          if item.present? && item_sellable?(item)
            ItemClearanceProcessor.new(item, @batch.id).run!
            @items_clearanced_count += 1
          end
        end
      end
    end
  end

  def item_id_valid?(id_from_csv)
    errors = []
    
    errors << "Row: #{@row_position} - (id: #{id_from_csv}) is blank!" if id_from_csv.nil? || id_from_csv.blank?
    errors << "Row: #{@row_position} - (id: #{id_from_csv}) is invalid!" if id_from_csv === "0"

    if errors.any?
      @errors << errors
      false
    else
      true
    end
  end

  def find_item(id_from_csv)
    item = Item.where(id: id_from_csv).first
    errors << "Row: #{@row_position} - (id: #{id_from_csv}) Could not be found!" if item.nil?
    item
  end

  def item_sellable?(item)
    if item.sellable?
      true
    else
      @errors << "Row: #{@row_position} - (id: #{item.id}) Item not sellable!"
      false
    end
  end

  def transaction(&blk)
    ApplicationRecord.transaction do
      yield
    end
  end
end

