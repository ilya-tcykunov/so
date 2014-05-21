require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Create comment', %q{
  In order express opinion concerned answer or question
  An an authenticated user
  I want to be able to create comment
} do
  given(:user){create(:user)}
  given(:question){create(:question)}
  given!(:his_comment){create(:questions_comment, commentable: question, user: user)}
  given!(:anothers_comment){create(:questions_comment, commentable: question)}

  scenario 'Unauthorized user wants to edit comments' do
    visit question_path(question)
    expect(page).not_to have_selector('[data-comment-edit-button-for-id]')
    expect(page).not_to have_selector('[data-comment-form-for-id]')
  end

  context 'Authorized user' do
    before :each do
      login_as(user, scope: :user)
      visit question_path(question)
    end

    scenario 'wants to edit anothers comment', js: true do
      expect(page).to have_selector("[data-comment-body-for-id='#{anothers_comment.id}']")
      expect(page).to have_no_selector("[data-comment-edit-button-for-id='#{anothers_comment.id}']")
      expect(page).to have_no_selector("[data-comment-form-for-id='#{anothers_comment.id}']")
    end

    context 'wants to edit his comment' do
      before :each do
        login_as(user, scope: :user)
        visit question_path(question)
        find("[data-comment-edit-button-for-id='#{his_comment.id}']").click
      end

      scenario 'with valid data', js: true do
        new_body = 'asfuina oo8neo8on h 2w '

        within("[data-comment-form-for-id='#{his_comment.id}']") do
          fill_in 'comment_body', with: new_body
          click_on 'Update Comment'
        end
        expect(find("[data-comment-body-for-id='#{his_comment.id}']")).to have_content(new_body)
      end

      scenario 'with invalid data', js: true do
        within("[data-comment-form-for-id='#{his_comment.id}']") do
          fill_in 'comment_body', with: ''
          click_on 'Update Comment'
        end
        expect(find("[data-comment-form-for-id='#{his_comment.id}'] .error-messages")).to have_content("Body can't be blank")
      end
    end
  end
end