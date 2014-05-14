class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  def index
  end

  def show
    if can? :new, Answer
      @answer = Answer.new
    end
  end

  def new
  end

  def edit
  end

  def create
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Question successfully created'
      redirect_to @question
    else
      render 'new'
    end
  end

  def update
    if @question.update(question_params)
      flash[:notice] = 'Question successfully updated'
      redirect_to @question
    else
      render 'edit'
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
