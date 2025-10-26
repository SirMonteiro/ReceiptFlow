Feature: NF-e Import
  As a user,
  I want to upload an NF-e XML file
  So that the data is imported into the database and displayed.

  Scenario: Successfully uploading a valid NF-e XML
    Given I am on the NF-e Importer page
    When I attach the file "NFe_assinada.xml" to the "xml_file" field
    And I press "Upload and Import NF-e"
    Then I should see a success message "Successfully imported NF-e"
    And I should see "Invoice #1 (Series: 1)"
    And I should see "Access Key: 35080599999090910270550010000000015180051273"
    And I should see "Agua Mineral" in the items table
    And the database should contain 1 NotaFiscal
    And the database should contain 2 ItemNotas