require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Editing answer', %q{
  In order to make marks in his answers
  As an author of the answer
  I want to be able to use editing mechanisms
} do

  given(:user){create(:user)}
  given(:question){create(:question)}
  given!(:his_answer){create(:answer, question: question, user: user)}
  given!(:anothers_answer){create(:answer, question: question)}


  scenario 'Unauthorized user wants to find buttons to edit answer' do
    visit question_path(question)

    expect(page).to have_xpath("//p[@data-answer-body-for-id]")
    expect(page).to have_no_xpath("//button[@data-answer-edit-button-for-id]")
    expect(page).to have_no_xpath("//form[@data-answer-edit-form-for-id]")
  end

  scenario "Authorized user wants to find button to edit another's answer", js: true do
    login_as(user, scope: :user)
    visit question_path(question)

    expect(page).to have_xpath("//p[@data-answer-body-for-id='#{anothers_answer.id}']")
    expect(page).to have_no_xpath("//button[@data-answer-edit-button-for-id='#{anothers_answer.id}']")
    expect(page).to have_no_xpath("//form[@data-answer-edit-form-for-id='#{anothers_answer.id}']")
  end

  scenario "Authorized user wants to find button to edit his answer", js: true do
    login_as(user, scope: :user)
    visit question_path(question)

    # The form should be hidden
    expect(page).to have_no_xpath("//form[@data-answer-edit-form-for-id='#{his_answer.id}']")

    # The button should be
    find(:xpath, "//button[@data-answer-edit-button-for-id='#{his_answer.id}']").click

    # The form should appear by clicking the button
    expect(page).to have_xpath("//form[@data-answer-edit-form-for-id='#{his_answer.id}']")
  end

  context 'Authorized user wants to edit his answer'  do
    before :each do
      login_as(user, scope: :user)
      visit question_path(question)
      find(:xpath, "//button[@data-answer-edit-button-for-id='#{his_answer.id}']").click
    end

    scenario 'with valid data', js: true do
      new_body = 'oiw843eytn5c724gn287mva e q 54o7gq'

      expect(page).to have_no_xpath("//p[@data-answer-body-for-id='#{his_answer.id}']", text: new_body)

      within(:xpath, "//form[@data-answer-edit-form-for-id='#{his_answer.id}']") do
        fill_in 'answer_body', with: new_body
        click_on 'Update Answer'
      end

      expect(page).to have_xpath("//p[@data-answer-body-for-id='#{his_answer.id}']", text: new_body)
    end

    scenario 'with invalid data', js: true do
      within(:xpath, "//form[@data-answer-edit-form-for-id='#{his_answer.id}']") do
        fill_in 'answer_body', with: ''
        click_on 'Update Answer'
      end

      expect(page).to have_xpath("//p[@data-answer-body-for-id='#{his_answer.id}']", text: his_answer.body)
      expect(find(:xpath, "//form[@data-answer-edit-form-for-id='#{his_answer.id}']")).to have_content("Body can't be blank")
    end
  end
end