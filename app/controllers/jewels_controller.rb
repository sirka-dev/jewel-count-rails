class JewelsController < ApplicationController
  def index
  end

  def show
  end

  def create
    logger.debug "DBに入れまーす"
    logger.debug "  count:" + params["count"]
    logger.debug "  time:" + Time.now.to_s(:db)

    instance = Jewel.new( count: params["count"], date: Time.now.to_s(:db) )
    instance.save

    render action: :index
  end
end
