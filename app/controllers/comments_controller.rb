class CommentsController < ApplicationController
  before_action :authenticate_user!
  load_resource :question
  load_resource :answer
  load_and_authorize_resource :comment, through: [:question, :answer]

  def create
    @comment.user = current_user
    @success = @comment.save
  end

  def update
    @success = @comment.update(comment_params)
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
