require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Editing new question', %{
  In order to edit question
  as authorized user
  new data should be valid and the question should belong to the current user
} do
  given(:user){create(:user)}
  given(:his_question){create(:question, user: user)}
  given(:anothers_question){create(:question)}

  background do
    login_as(user, scope: :user)
  end

  context 'Editing his question' do
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

  scenario "Editing another's question" do
    expect{
      visit edit_question_path(anothers_question)
    }.to raise_error(CanCan::AccessDenied)
  end
end

