class TagsController < ApplicationController
  respond_to :json
  layout false

  def index
    @tags = Tag.all
    respond_with @tags
  end
end
