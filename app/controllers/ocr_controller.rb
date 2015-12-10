class OcrController < ApplicationController
  before_action :authenticate_user!

  
  def process_image
    ocr = OCRFormatter.new
    @results = ocr.import_recipe(params[:my_image].tempfile.path)
    render "process_image.json.jbuilder", status: :ok
  end

end
