# app/services/xml_import_service.rb
#
# This is a "Service Object". It's a plain old Ruby object (PORO)
# designed to do one specific job: import data from an XML file.
# This keeps our controller clean and makes this logic easy to test.
#
# We need to add the 'nokogiri' gem to our Gemfile for this to work:
# Run: bundle add nokogiri
#
require 'nokogiri'

class XmlImportService
  # We'll pass the uploaded file to this 'call' method
  def self.call(uploaded_file)
    # The uploaded file needs to be read.
    # We can use .tempfile to get a standard File object
    file = uploaded_file.tempfile

    # Use Nokogiri to parse the XML document
    doc = Nokogiri::XML(file)

    # We'll use .xpath() to find all <product> nodes within <products>
    # This is a very powerful way to query XML.
    product_nodes = doc.xpath('//products/product')

    product_nodes.each do |node|
      # Use .at_xpath() to find the first matching child node
      # and .text to get its content.
      name = node.at_xpath('name')&.text
      price = node.at_xpath('price')&.text
      description = node.at_xpath('description')&.text

      # Now, we create the Product record in our database
      # We use create! (with a bang) so that if a validation fails
      # (e.g., no name), it will raise an error which our controller
      # can rescue.
      Product.create!(
        name: name,
        price: price.to_f,
        description: description
      )
    end

    # Return the count of imported products
    product_nodes.count
  end
end
