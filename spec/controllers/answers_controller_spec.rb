require 'spec_helper'

describe AnswersController do
  describe 'POST #create' do
    context 'when user is not signed in' do
      it 'can not create answers' do
        post :create, answer: attributes_for(:answer), question_id: create(:question)
        expect(response).to redirect_to new_user_session_path
      end

      it 'can not create answers using ajax' do
        post :create, answer: attributes_for(:answer), question_id: create(:question), format: :js
        expect(response.status).to eq 401
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

  describe 'PATCH #update' do
    context 'when user is not signed in' do
      let(:question){create(:question)}
      let!(:answer){create(:answer, question: question)}

      it 'can not update answers' do
        patch :update,
              id: answer,
              question_id: question,
              answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end

      it 'can not update answers using ajax' do
        patch :update,
              id: answer,
              question_id: question,
              answer: attributes_for(:answer),
              format: :js
        expect(response.status).to eq 401
      end
    end

    context 'when user is signed in' do
      let(:user) {create(:user)}
      let(:question) {create(:question)}
      let!(:his_answer) {create(:answer, question: question, user: user)}
      let!(:anothers_answer) {create(:answer, question: question)}

      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end

      context "when updating another's answer" do
        it 'he has not access' do
          expect{
            patch :update,
                  id: anothers_answer,
                  question_id: question,
                  answer: attributes_for(:answer),
                  format: :js
          }.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'when updating his answer' do
        context 'with valid data' do
          let(:valid_new_body){'seifnrgoojbsokie'}

          before :each do
            patch :update,
                  id: his_answer,
                  question_id: question,
                  answer: attributes_for(:answer, body: valid_new_body),
                  format: :js
          end

          it 'has correct @answer variable' do
            expect(assigns(:answer).id).to eq his_answer.id
          end

          it 'has correct @success variable' do
            expect(assigns(:success)).to be_true
          end

          it 'changes attributes' do
            his_answer.reload
            expect(his_answer.body).to eq valid_new_body
          end

          it 'renders update template' do
            expect(response).to render_template :update
          end
        end

        context 'with invalid data' do
          let(:invalid_new_body){''}

          before :each do
            patch :update,
                  id: his_answer,
                  question_id: question,
                  answer: attributes_for(:answer, body: invalid_new_body),
                  format: :js
          end

          it 'has correct @answer variable' do
            expect(assigns(:answer).id).to eq his_answer.id
          end

          it 'has correct @success variable' do
            expect(assigns(:success)).to be_false
          end

          it 'does not change attributes' do
            his_answer.reload
            expect(his_answer.body).not_to eq invalid_new_body
          end

          it 'renders update template' do
            expect(response).to render_template :update
          end
        end
      end
    end
  end
end
