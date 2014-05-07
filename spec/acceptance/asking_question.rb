require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Pushing "Ask question" button', %q{
  In order to ask question
  As unauthorized user
  He must be authorized first
} do

  scenario 'Unauthorized user pushes "Ask question button"' do
    visit root_path
    click_on 'Ask question'

    expect(page).to have_content 'Sign in'
  end

  scenario 'Authorized user pushes "Ask question" button' do
    login_as(create(:user), scope: :user)

    visit root_path
    click_on 'Ask question'

    expect(page).to have_selector(:link_or_button, 'Create Question')
  end
end

feature 'Creating new question', %{
  In order to post new question
  as authorized user
  the question should be valid
} do
  background do
    login_as(create(:user), scope: :user)
    visit new_question_path
  end

  scenario 'Question data is invalid' do
    fill_in 'Title', with: ''
    click_on 'Create Question'

    expect(page).to have_content "Title can't be blank"
  end

  scenario 'Question data is valid' do
    fill_in 'Title', with: 'the title'
    fill_in 'Body', with: 'the body'
    click_on 'Create Question'

    expect(page).to have_content "Question successfully created"
  end
end

feature 'Editing new question', %{
  In order to edit question
  as authorized user
  new data should be valid and order should belong to the current user
} do
  given(:user){create(:user)}
  given(:his_question){create(:question, user: user)}
  given(:anothers_question){create(:question)}

  background do
    login_as(user, scope: :user)
  end

  feature 'Editing his question' do
    background do
      visit edit_question_path(his_question)
    end

    scenario 'with valid data' do
      fill_in 'Title', with: 'cmon'
      click_on 'Update Question'

      expect(page).to have_content "Question successfully updated"
    end

    scenario 'with invalid data' do
      fill_in 'Title', with: ''
      click_on 'Update Question'

      expect(page).to have_content "Title can't be blank"
    end

  end

  scenario 'Editing anothers question' do
    expect{
      visit edit_question_path(anothers_question)
    }.to raise_error(CanCan::AccessDenied)
  end
end

