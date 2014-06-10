class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :question
  load_resource :answer
  load_and_authorize_resource :comment, through: [:question, :answer]

  def create
    @comment.user = current_user
    respond_routine
  end

  def update
    respond_routine
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def respond_routine
    respond_to do |format|
      record_exists = !@comment.new_record?
      result = if record_exists
                 @comment.update(comment_params)
               else
                 @comment.save
               end
      if result
        question = @question || @answer.question
        commentable = @question || @answer
        editable_comment = render_to_string(partial: 'comments/editable_comment', locals: { comment: @comment }, layout: false)
        data = {type: 'comment',
                id: @comment.id,
                commentable_type: commentable.class.name.underscore,
                commentable_id: commentable.id,
                user_id: current_user.id,
                action: record_exists ? 'update' : 'create',
                html: editable_comment}
        PrivatePub.publish_to("/admin/questions/#{question.id}", data: data)

        data[:html] = render_to_string(partial: 'comments/readonly_comment', locals: { comment: @comment }, layout: false)
        PrivatePub.publish_to("/questions/#{question.id}", data: data)

        format.json { render json: { html: editable_comment } }
      else
        errors = render_to_string(partial: 'common/error_messages', locals: { model: @comment }, layout: false)
        format.json { render json: { html: errors }, status: :unprocessable_entity }
      end
    end
  end
end
