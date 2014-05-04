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
end
