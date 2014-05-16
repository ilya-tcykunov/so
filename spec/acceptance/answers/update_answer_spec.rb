require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Editing answer', %q{
  In order to make marks in his questions
  As an author of the answers
  I want to be able to use editing mechanisms
} do

  given(:question){create(:question)}
  given(:user){create(:user)}
  given!(:his_answer){create(:answer, question: question, user: user, body: 'his answer')}
  given!(:anothers_answer){create(:answer, question: question, body: 'anothers answer')}

  scenario 'Unauthorized user wants to find buttons to edit answers' do
    visit question_path(question)

    expect(page).to have_xpath("//p[@data-answer-text-for-id]")
    expect(page).to have_no_xpath("//button[@data-answer-edit-button-for-id]")
    expect(page).to have_no_xpath("//form[@data-answer-edit-form-for-id]")
  end

  scenario "Authorized user wants to edit another's answer" do
    login_as(user, scope: :user)
    visit question_path(question)

    expect(page).to have_xpath("//p[@data-answer-text-for-id='#{anothers_answer.id}']")
    expect(page).to have_no_xpath("//button[@data-answer-edit-button-for-id='#{anothers_answer.id}']")
    expect(page).to have_no_xpath("//form[@data-answer-edit-form-for-id='#{anothers_answer.id}']")
  end

  scenario 'Authorized user wants to edit his answer' do
    login_as(user, scope: :user)
    visit question_path(question)

    # Form should be hidden
    expect(find(:xpath, "//form[@data-answer-edit-form-for-id='#{his_answer.id}']", visible: false)).not_to be_visible

    find(:xpath, "//button[@data-answer-edit-button-for-id='#{his_answer.id}']").click
    # The form should appear by clicking the button
    expect(page).to have_xpath("//form[@data-answer-edit-form-for-id='#{his_answer.id}']")
  end
end