class ProductsController < ApplicationController
    # This action will show our upload form
    def index
      @products = Product.all
      # This will also implicitly render app/views/products/index.html.erb
    end
  
    # This action will be the target of our form
    def import
      # Ensure a file was actually uploaded
      file = params[:xml_file]
      if file.nil?
        redirect_to products_path, alert: 'No file selected. Please choose an XML file.'
        return
      end
  
      # Use our service object to do the work
      begin
        imported_count = XmlImportService.call(file)
        redirect_to products_path, notice: "Successfully imported #{imported_count} products!"
      rescue => e
        # If anything goes wrong (parsing error, validation error),
        # we'll catch it here and show an alert.
        redirect_to products_path, alert: "Error importing file: #{e.message}"
      end
    end
  end
  