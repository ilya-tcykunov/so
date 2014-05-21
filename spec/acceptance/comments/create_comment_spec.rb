require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create comment', %q{
  In order express opinion concerned answer or question
  An an authenticated user
  I want to be able to create comment
} do
  given(:question){create(:question)}
  given!(:answer){create(:answer, question: question)}

  scenario 'Unauthorized user wants to create comment' do
    visit question_path(question)
    expect(page).not_to have_selector('new_comment')
    expect(page).not_to have_selector('[data-comment-new-button]')
  end

  context 'Authorized user' do
    before :each do
      login_as(create(:user), scope: :user)
      visit question_path(question)
    end

    scenario 'creates valid comment to question', js: true do
      expect(page).to have_no_selector("[data-question-container] #new_comment")

      within('[data-question-container]') do
        click_on 'Comment'
      end

      new_comment = 'my new comment'

      expect(page).not_to have_content(new_comment)

      # The form should appear by clicking the button
      expect(page).to have_selector("[data-question-container] #new_comment")

      within("[data-question-container] #new_comment") do
        fill_in 'comment_body', with: new_comment
        click_on 'Create Comment'
      end

      expect(page).to have_selector('[data-question-container] [data-comment-body-for-id]', text: new_comment)
    end

    scenario 'Authenticated user creates valid comment to answer', js: true do
      expect(page).to have_no_selector("[data-answers-container] #new_comment")

      within('[data-answers-container]') do
        click_on 'Comment'
      end

      new_comment = 'sdviuh8w4vbvbn8 8w4vhsan df'

      expect(page).not_to have_content(new_comment)

      # The form should appear by clicking the button
      expect(page).to have_selector("[data-answers-container] #new_comment")

      within("[data-answers-container] #new_comment") do
        fill_in 'comment_body', with: new_comment
        click_on 'Create Comment'
      end

      expect(page).to have_selector('[data-answers-container] [data-comment-body-for-id]', text: new_comment)
    end

    scenario 'Authenticated user creates invalid comment to question', js: true do
      login_as(create(:user), scope: :user)
      visit question_path(question)

      expect(page).to have_no_selector("[data-question-container] #new_comment")

      within('[data-question-container]') do
        click_on 'Comment'
      end

      expect(page).not_to have_content("Body can't be blank")

      # The form should appear by clicking the button
      expect(page).to have_selector("[data-question-container] #new_comment")

      within("[data-question-container] #new_comment") do
        fill_in 'comment_body', with: ''
        click_on 'Create Comment'
      end

      expect(page).to have_selector('[data-question-container] #new_comment .error-messages', text: "Body can't be blank")
    end

    scenario 'Authenticated user creates invalid comment to answer', js: true do
      login_as(create(:user), scope: :user)
      visit question_path(question)

      expect(page).to have_no_selector("[data-answers-container] #new_comment")

      within('[data-answers-container]') do
        click_on 'Comment'
      end

      expect(page).not_to have_content("Body can't be blank")

      # The form should appear by clicking the button
      expect(page).to have_selector("[data-answers-container] #new_comment")

      within("[data-answers-container] #new_comment") do
        fill_in 'comment_body', with: ''
        click_on 'Create Comment'
      end

      expect(page).to have_selector('[data-answers-container] #new_comment .error-messages', text: "Body can't be blank")
    end
  end
end