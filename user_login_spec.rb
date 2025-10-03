# spec/features/user_login_spec.rb
require 'rails_helper'

RSpec.feature "UserLogins", type: :feature do
  # Create the user from the factory before the test runs
  let!(:user) { create(:user, email: "tester@example.com", password: "password") }

  scenario "User logs in successfully with valid credentials" do
    # 1. Visit the login page
    visit login_path

    # 2. Fill in the form with valid data
    fill_in "Email", with: "tester@example.com"
    fill_in "Password", with: "password"
    click_button "Log in"

    # 3. Expect to be redirected to the welcome page and see a success message
    expect(current_path).to eq(welcome_path)
    expect(page).to have_content("Logged in successfully")
    expect(page).to have_content("Welcome to ReceiptFlow!")
    expect(page).to have_link("Log Out")
    expect(page).to have_no_link("Log In")
  end

  scenario "User fails to log in with invalid credentials" do
    # 1. Visit the login page
    visit login_path

    # 2. Fill in the form with invalid data
    fill_in "Email", with: "tester@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    # 3. Expect to stay on the login page and see an error message
    expect(current_path).to eq(login_path)
    expect(page).to have_content("There was something wrong with your login details")
  end
end

# spec/features/user_login_spec.rb
require 'rails_helper'

RSpec.feature "User Authentication", type: :feature do
  
  feature "User logs in" do
    scenario "with valid credentials" do
      # GIVEN a user account exists
      create(:user, email: "tester@example.com", password: "password")
      
      # WHEN I visit the login page and submit the form with correct details
      visit login_path
      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password"
      click_button "Log in"
      
      # THEN I am redirected to the welcome page and see a success message
      expect(current_path).to eq(welcome_path)
      expect(page).to have_content("Logged in successfully")
      expect(page).to have_link("Log Out")
    end

    scenario "with invalid credentials" do
      # GIVEN a user account exists
      create(:user, email: "tester@example.com", password: "password")
      
      # WHEN I submit the form with an incorrect password
      visit login_path
      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"
      
      # THEN I remain on the login page and see an error message
      expect(current_path).to eq(login_path)
      expect(page).to have_content("There was something wrong with your login details")
      expect(page).to have_no_link("Log Out")
    end
  end

  feature "User logs out" do
    scenario "successfully after being logged in" do
      # GIVEN I am a logged-in user
      user = create(:user)
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      
      # WHEN I click the 'Log Out' link
      click_link "Log Out"
      
      # THEN I am redirected to the login page and see a logged-out message
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Logged out")
      expect(page).to have_link("Log In")
    end
  end
end