class QuestionsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @question.user = current_user
    if @question.save
      redirect_to @question
    else
      render 'new'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
