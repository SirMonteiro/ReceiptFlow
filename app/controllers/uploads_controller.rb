class UploadsController < ApplicationController
  # This action prepares an empty @upload object for our form.
  def new
    @upload = Upload.new
  end

  # This action handles the form submission.
  def create
    @upload = Upload.new(upload_params)

    if @upload.save
      # If the upload saves successfully, redirect to the home page with a success message.
      # In a real app, you might process the file here.
      redirect_to root_path, notice: "File uploaded successfully!"
    else
      # If it fails, re-render the form.
      render :new
    end
  end

  private

  # This is a security feature (Strong Parameters) to only allow the :xml_file attribute.
  def upload_params
    params.require(:upload).permit(:xml_file)
  end
end