class VotingsController < ApplicationController
  before_action :authenticate_user!
  load_resource :question
  load_resource :answer
  load_and_authorize_resource :voting, through: [:question, :answer]

  def create
    votable = @question || @answer
    voting = votable.voting_of(current_user)
    if voting.present?
      @voting = voting
    end

    if params[:opinion] == 'up'
      @voting.up
    elsif params[:opinion] == 'down'
      @voting.down
    end
    @voting.user = current_user

    respond_to do |format|
      if @voting.save
        question = @question || @answer.question
        common_opinion = votable.common_opinion
        data = {chunk_type: Voting.name.underscore,
                chunk_author_id: votable.user.id,
                votable_type: votable.class.name.underscore,
                votable_id: votable.id,
                actor_id: current_user.id,
                html: common_opinion}
        PrivatePub.publish_to("/admin/questions/#{question.id}", data: data)
        PrivatePub.publish_to("/chunk_author/questions/#{question.id}", data: data)
        PrivatePub.publish_to("/questions/#{question.id}", data: data)

        format.json { render json: { html: common_opinion } }
      else
        format.json { render json: { html: '' }, status: :unprocessable_entity }
      end
    end
  end
end