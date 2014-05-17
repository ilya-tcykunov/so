require_relative '../acceptance_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Editing question', %q{
  In order to make marks in his question
  As an author of the answer
  I want to be able to use editing mechanisms
} do

  given(:user){create(:user)}
  given!(:his_question){create(:question, user: user)}
  given!(:anothers_question){create(:question)}


  scenario 'Unauthorized user wants to find buttons to edit question' do
    visit question_path(create(:question))

    expect(page).to have_xpath("//h2[@data-question-title-for-id]")
    expect(page).to have_xpath("//p[@data-question-body-for-id]")
    expect(page).to have_no_xpath("//button[@data-question-edit-button-for-id]")
    expect(page).to have_no_xpath("//form[@data-question-edit-form-for-id]")
  end

  scenario "Authorized user wants to find button to edit another's question", js: true do
    login_as(user, scope: :user)
    visit question_path(anothers_question)

    expect(page).to have_xpath("//h2[@data-question-title-for-id='#{anothers_question.id}']")
    expect(page).to have_xpath("//p[@data-question-body-for-id='#{anothers_question.id}']")
    expect(page).to have_no_xpath("//button[@data-question-edit-button-for-id='#{anothers_question.id}']")
    expect(page).to have_no_xpath("//form[@data-question-edit-form-for-id='#{anothers_question.id}']")
  end

  scenario "Authorized user wants to find button to edit his question", js: true do
    login_as(user, scope: :user)
    visit question_path(his_question)

    # The form should be hidden
    expect(page).to have_no_xpath("//form[@data-question-edit-form-for-id='#{his_question.id}']")

    # The button should be
    find(:xpath, "//button[@data-question-edit-button-for-id='#{his_question.id}']").click

    # The form should appear by clicking the button
    expect(page).to have_xpath("//form[@data-question-edit-form-for-id='#{his_question.id}']")
  end

  context 'Authorized user wants to edit his answer'  do
    before :each do
      login_as(user, scope: :user)
      visit question_path(his_question)
      find(:xpath, "//button[@data-question-edit-button-for-id='#{his_question.id}']").click
    end

    scenario 'with valid data', js: true do
      new_title = 'asidvbouaerouvbqa83r'
      new_body = 'oiw843eytn5c724gn287mva e q 54o7gq'

      expect(page).to have_no_xpath("//h2[@data-question-title-for-id='#{his_question.id}']", text: new_title)
      expect(page).to have_no_xpath("//p[@data-question-body-for-id='#{his_question.id}']", text: new_body)

      within(:xpath, "//form[@data-question-edit-form-for-id='#{his_question.id}']") do
        fill_in 'Title', with: new_title
        fill_in 'Body', with: new_body
        click_on 'Update Question'
      end

      expect(page).to have_xpath("//h2[@data-question-title-for-id='#{his_question.id}']", text: new_title)
      expect(page).to have_xpath("//p[@data-question-body-for-id='#{his_question.id}']", text: new_body)
    end

    scenario 'with invalid data', js: true do
      within(:xpath, "//form[@data-question-edit-form-for-id='#{his_question.id}']") do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Update Question'
      end

      expect(page).to have_xpath("//h2[@data-question-title-for-id='#{his_question.id}']", text: his_question.title)
      expect(page).to have_xpath("//p[@data-question-body-for-id='#{his_question.id}']", text: his_question.body)
      expect(find(:xpath, "//form[@data-question-edit-form-for-id='#{his_question.id}']")).to have_content("Title can't be blank")
      expect(find(:xpath, "//form[@data-question-edit-form-for-id='#{his_question.id}']")).to have_content("Body can't be blank")
    end
  end
end