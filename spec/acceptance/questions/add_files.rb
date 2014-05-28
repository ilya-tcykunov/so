require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to extend the context of my question
  An a author of the question
  I'd like to add files
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User adds files when asking question' do
    login_as(user, scope: :user)
    visit new_question_path
    fill_in 'Title', with: 'new title'
    fill_in 'Body', with: 'new body'
    attach_file 'File', Rails.root.join('spec', 'spec_helper.rb')

    click_on 'Create Question'

    expect(page).to have_content 'spec_helper.rb'
  end
end