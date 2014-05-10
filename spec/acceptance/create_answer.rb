require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'User answer', %q{
  In order to exchange knowledge
  An an authenticated user
  I want to be able to create answers
} do
  given(:question){create(:question)}

  scenario 'Authenticated user creates answer', js: true do
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
end