require 'spec_helper'

describe QuestionsController do
  include Devise::TestHelpers

  describe 'GET #index' do
    let(:questions){create_list(:question, 2)}

    before :each do
      get :index
    end

    context 'when user is not signed in' do
      it 'should have all questions in @questions' do
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'renders index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'when user signed in' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in create(:user)
      end

      it 'should have all questions in @questions' do
        expect(assigns(:questions)).to match_array(questions)
      end

      it 'renders index template' do
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #show' do
    let(:question){create(:question)}

    context 'when user is not signed in' do
      before :each do
        get :show, id: question
      end

      it 'has @question variable' do
        expect(assigns(:question)).to eq question
      end

      it 'renders show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'when user signed in' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in create(:user)
        get :show, id: question
      end

      it 'has @question variable' do
        expect(assigns(:question)).to eq question
      end

      it 'renders show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #new' do
    context 'when user is not signed in' do
      it 'can not create questions' do
        expect {
          get :new
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user signed in' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in create(:user)
        get :new
      end

      it 'has @question variable' do
        expect(assigns(:question)).not_to be_nil
      end

      it 'renders new template' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'when user is not signed in' do
      it 'can not edit questions' do
        expect {
          get :edit, id: create(:question)
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is signed in' do
      let(:user) {create(:user)}
      let(:his_question) {create(:question, user: user)}
      let(:anothers_question) {create(:question)}

      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in user
      end

      context "when editing another's question" do
        it 'has not access' do
          expect{
            get :edit, id: anothers_question
          }.to raise_error(CanCan::AccessDenied)
        end
      end

      context 'when editing his question' do
        before :each do
          get :edit, id: his_question
        end

        it 'has correct @question' do
          expect(assigns(:question)).to eq his_question
        end

        it 'renders edit template' do
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not signed in' do
      it 'can not edit questions' do
        expect {
          get :edit, id: create(:question)
        }.to raise_error(CanCan::AccessDenied)
      end
    end

    context 'when user is signed in' do
      before :each do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in create(:user)
      end

      context "with valid attributes" do
        it 'saves new question to database' do
          expect{post :create, question: attributes_for(:question)}.to change(Question, :count).by(1)
        end

        it 'set correct user to created question' do
          post :create, question: attributes_for(:question)
          expect(Question.last.user).to eq subject.current_user
        end

        it 'redirects to show' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do
        it 'does not save new question to database' do
          expect{post :create, question: attributes_for(:question_empty_title)}.not_to change(Question, :count)
        end

        it 're-renders new template' do
          post :create, question: attributes_for(:question_empty_title)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
