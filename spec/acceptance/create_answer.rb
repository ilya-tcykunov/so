require_relative 'acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User answer', %q{
  In order to exchange knowledge
  An an authenticated user
  I want to be able to create answers
} do
  given(:question){create(:question)}

  scenario 'Unauthorized user wants to create answer' do
    visit question_path(question)
    expect(page).not_to have_selector('#new_answer')
    expect(page).to have_content('You should sign in to answer')
  end

  scenario 'Authenticated user creates valid answer', js: true do
    login_as(create(:user), scope: :user)
    visit question_path(question)

    within('#new_answer') do
      fill_in 'answer_body', with: 'my answer'
      click_on 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    within('[data-answers-container]') do
      expect(page).to have_content 'my answer'
    end
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    login_as(create(:user), scope: :user)
    visit question_path(question)

    within('#new_answer') do
      fill_in 'answer_body', with: ''
      click_on 'Create Answer'
    end

    expect(current_path).to eq question_path(question)
    within('.error-messages') do
      expect(page).to have_content "Body can't be blank"
    end
  end
end