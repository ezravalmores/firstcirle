class ClearanceBatchesController < ApplicationController
  def index
    @clearance_batches  = ClearanceBatch.all
  end

  def show
    @clearance_batch = ClearanceBatch.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
          render pdf: "Batch No. #{@clearance_batch.id}",
          page_size: 'A4',
          template: "clearance_batches/show.html.erb",
          layout: "pdf.html",
          orientation: "Landscape",
          lowquality: true,
          zoom: 1,
          dpi: 75
      end
    end
  end

  def create
    batch_service = ClearanceItemsFromCsvService.new(params[:csv_batch_file].tempfile)
    batch_service.process!

    errors = []

    if batch_service.batch.persisted?
      flash[:notice] = "Batch successfully created!"
    else
      flash[:alert] = "Batch was not created and no item were clearanced!"
    end

    if batch_service.errors.any?
      batch_service.errors.flatten.each {|error| errors << error }
    end

    if batch_service.items_clearanced_count > 0
      flash[:success] = "#{batch_service.items_clearanced_count} items(s) clearanced! Check report"
    end

    flash[:alert] = errors.join("<br/>") if errors.any?
    redirect_to action: :index
  end
end
