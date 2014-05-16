require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Creating new question', %q{
  In order to get help from community
  An authorized user
  Could be able to create new question
} do

  context 'when pushing "Ask question" button' do
    scenario 'as unauthorized user' do
      visit root_path
      click_on 'Ask question'

      expect(page).to have_content 'Sign in'
    end

    scenario 'as authorized user' do
      login_as(create(:user), scope: :user)

      visit root_path
      click_on 'Ask question'

      expect(page).to have_selector(:link_or_button, 'Create Question')
    end
  end

  context 'when filling the form' do
    background do
      login_as(create(:user), scope: :user)
      visit new_question_path
    end

    scenario 'with invalid data' do
      fill_in 'Title', with: ''
      click_on 'Create Question'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'with valid data' do
      fill_in 'Title', with: 'new title'
      fill_in 'Body', with: 'new body'
      click_on 'Create Question'

      expect(page).to have_content "Question successfully created"
      expect(page).to have_content "new title"
      expect(page).to have_content "new body"
    end
  end
end