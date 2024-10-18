class StoriesController < ApplicationController
  before_action :validate_id, except: %i[index new_stories]

  def index
    stories = StoriesService.new.get_stories

    render json: stories
  end

  def show
    story = StoriesService.new.get_story(params[:id])

    if story.blank?
      render json: { error: 'Story not found!' }, status: :not_found
    else
      render json: story
    end
  end

  def new_stories
    stories = StoriesService.new.get_stories('new', params[:filter_term])

    render json: stories.first(10)
  end

  def comments
    comments = StoriesService.new.get_comments(params[:id])

    render json: comments
  rescue => e
    return render json: { error: e.message }, status: :not_found if e.message == 'Story not found'

    render json: { error: 'Failed to fetch comments' }, status: :internal_server_error
  end

  private

  def validate_id
    return render json: { error: 'Invalid Story ID' }, status: :bad_request unless params[:id].to_i.positive?
  end
end
