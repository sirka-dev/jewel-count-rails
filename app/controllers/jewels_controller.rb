class JewelsController < ApplicationController
  def index
    # @list = Jewel.where( delflag: false )
    @list = Jewel.all
  end

  def show
  end

  def restore
    logger.debug params[:id]

    Jewel.where(id: params[:id]).update( delflag: false )
    redirect_to :root
  end

  def delete
    logger.debug params[:id]

    Jewel.where(id: params[:id]).update( delflag: true )
    redirect_to :root
  end

  def create
    logger.debug "DBに入れまーす"
    logger.debug "  count:" + params["count"]
    logger.debug "  time:" + Time.now.to_s(:db)

    jewel = Jewel.new( count: params["count"], date: Time.now.to_s(:db) )
    jewel.save

    redirect_to :root
  end
end
