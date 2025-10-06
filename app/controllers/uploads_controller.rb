class UploadsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :handle_missing_file

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)

    if params[:upload] && params[:upload][:xml_file]
      @upload.file_name = params[:upload][:xml_file].original_filename
    end

    if @upload.save
      process_xml_file(@upload)
      redirect_to root_path, status: :see_other, notice: "Arquivo enviado e processado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def debug
    @upload = Upload.new
    render layout: false
  end

  private

  def upload_params
    params.require(:upload).permit(:xml_file)
  end

  def process_xml_file(upload)
    require 'pp'
    xml_content = upload.xml_file.download
    
    danfe_data = DanfeParser.new(xml_content).parse
    
    puts "--- EXTRACTED DANFE DATA ---"
    pp danfe_data
    puts "--------------------------"
  end
  
  def handle_missing_file
    flash[:alert] = "Por favor, selecione um arquivo para enviar."
    redirect_to new_upload_path 
  end
end