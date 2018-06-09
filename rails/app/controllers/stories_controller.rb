class StoriesController < ApplicationController
  def index
    @stories = Story.all
  end

  def search
    tags = params[:tags]
    @stories = Story.tagged_with(tags)
  end
end
