require 'spec_helper'

describe AnswersController do
  describe 'POST #create' do
    context 'when user is not signed in' do
      it 'can not create answers' do
        post :create, answer: attributes_for(:answer), question_id: create(:question)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user is signed in' do
      let(:question){create(:question)}

      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in create(:user)
      end

      context "with valid attributes" do
        it 'saves new answer to the database' do
          expect{post :create, answer: attributes_for(:answer), question_id: question, format: :js}.to change(question.answers, :count).by(1)
        end

        it 'set correct user to created answer' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(question.answers.last.user).to eq subject.current_user
        end

        it 'renders create template' do
          post :create, answer: attributes_for(:answer), question_id: question, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save new question to database' do
          expect{post :create, answer: attributes_for(:answer_empty_body), question_id: question, format: :js}.not_to change(Answer, :count)
        end

        it 'renders create template' do
          post :create, answer: attributes_for(:answer_empty_body), question_id: question, format: :js
          expect(response).to render_template :create
        end
      end
    end
  end

end
