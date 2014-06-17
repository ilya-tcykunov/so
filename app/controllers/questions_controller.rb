 class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  respond_to :json

  def index
  end

  def show
    if can? :new, Answer
      #@answer = Answer.new
      @answer = @question.answers.build
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
    respond_to do |format|
      if @question.update(question_params)
        question = render_to_string(partial: 'questions/editable_question', locals: { question: @question }, layout: false)
        data = {chunk_type: 'question',
                chunk_id: @question.id,
                chunk_author_id: @question.user.id,
                actor_id: current_user.id,
                action: 'update',
                html: question}
        PrivatePub.publish_to("/admin/questions/#{@question.id}", data: data)
        if current_user != @question.user
          PrivatePub.publish_to("/chunk_author/questions/#{@question.id}", data: data)
        end

        data[:html] = render_to_string(partial: 'questions/readonly_question', locals: { question: @question }, layout: false)
        PrivatePub.publish_to("/questions/#{@question.id}", data: data)

        format.json { render json: { html: question } }
      else
        errors = render_to_string(partial: 'common/error_messages', locals: { model: @question }, layout: false)
        format.json { render json: { html: errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
