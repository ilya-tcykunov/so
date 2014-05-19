require 'spec_helper'

describe CommentsController do
  describe 'POST #create' do
    context 'when user is not signed in' do
      it 'can not create comments for question' do
        post :create, comment: attributes_for(:comment), question_id: create(:question)
        expect(response).to redirect_to new_user_session_path
      end

      it 'can not create comments for answer' do
        post :create, comment: attributes_for(:comment), answer_id: create(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end