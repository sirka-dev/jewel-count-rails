class JewelsController < ApplicationController
  def index
  end

  def show
  end

  def create
    logger.debug params["count"]

    render action: :index
  end
end
