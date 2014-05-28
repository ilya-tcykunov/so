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
    @question.attachments.build
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
    @success = @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
