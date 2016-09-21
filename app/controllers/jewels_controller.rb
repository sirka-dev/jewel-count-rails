class JewelsController < ApplicationController
  @delFlag =  nil

  def index
    logger.debug params[:dispFlag]
    
    @delFlag = params[:dispFlag]
    case @delFlag
    when "0" then
      @list = Jewel.all.order(:date)
    when "2" then
      @list = Jewel.where(delflag: true).order(:date)
    else
      @list = Jewel.where(delflag: false).order(:date)
    end
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
