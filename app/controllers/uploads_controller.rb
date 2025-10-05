class UploadsController < ApplicationController
  # ADDED: This line will catch the error if no file is submitted.
  rescue_from ActionController::ParameterMissing, with: :handle_missing_file

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)

    if @upload.save
      process_xml_file(@upload)
      redirect_to root_path, status: :see_other, notice: "Arquivo enviado e processado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def debug
    @upload = Upload.new
    # This is the key: it tells Rails not to use any layout file.
    render layout: false
  end

  private

  def upload_params
    # This line remains the same. The error it throws is now handled gracefully.
    params.require(:upload).permit(:xml_file)
  end

  def process_xml_file(upload)
    require 'pp'
    xml_content = upload.xml_file.download
    
    # Use the new, tested service object
    danfe_data = DanfeParser.new(xml_content).parse
    
    puts "--- EXTRACTED DANFE DATA ---"
    pp danfe_data
    puts "--------------------------"
  end
  
  # ADDED: This method runs when the ParameterMissing error occurs.
  def handle_missing_file
    # Sets a user-friendly error message.
    flash[:alert] = "Por favor, selecione um arquivo para enviar."
    # Sends the user back to the upload form.
    redirect_to new_upload_path 
  end
end