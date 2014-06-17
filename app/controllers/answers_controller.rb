class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  load_and_authorize_resource :question
  load_and_authorize_resource :answer, through: :question

  def create
    @answer.user = current_user
    respond_to do |format|
      if @answer.save
        editable_answer_container = render_to_string(partial: 'answers/editable_answer_container', locals: { answer: @answer }, layout: false)
        data = {chunk_type: 'answer',
                chunk_id: @answer.id,
                chunk_author_id: @answer.user.id,
                actor_id: current_user.id,
                action: 'create',
                html: editable_answer_container}
        PrivatePub.publish_to("/admin/questions/#{@question.id}", data: data)

        data[:html] = render_to_string(partial: 'answers/readonly_answer_container', locals: { answer: @answer }, layout: false)
        PrivatePub.publish_to("/questions/#{@question.id}", data: data)

        format.json { render json: { html: editable_answer_container } }
      else
        errors = render_to_string(partial: 'common/error_messages', locals: { model: @answer }, layout: false)
        format.json { render json: { html: errors }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        editable_answer = render_to_string(partial: 'answers/editable_answer', locals: { answer: @answer }, layout: false)
        data = {chunk_type: 'answer',
                chunk_id: @answer.id,
                chunk_author_id: @answer.user.id,
                actor_id: current_user.id,
                action: 'update',
                html: editable_answer}
        PrivatePub.publish_to("/admin/questions/#{@question.id}", data: data)
        if current_user != @answer.user
          PrivatePub.publish_to("/chunk_author/questions/#{@question.id}", data: data)
        end

        data[:html] = render_to_string(partial: 'answers/readonly_answer', locals: { answer: @answer }, layout: false)
        PrivatePub.publish_to("/questions/#{@question.id}", data: data)

        format.json { render json: { html: editable_answer } }
      else
        errors = render_to_string(partial: 'common/error_messages', locals: { model: @answer }, layout: false)
        format.json { render json: { html: errors }, status: :unprocessable_entity }
      end
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
