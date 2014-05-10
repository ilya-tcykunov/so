class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question

  def create
    @answer.user = current_user
    @answer.save
    #redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
