class JewelsController < ApplicationController
  def index
    logger.debug params[:dispFlag]

    @count = Count.all.order(:count)

    @dispOption = { "デフォルト" => 1, "削除済み含む" => 0, "削除済みのみ" => 2 }

    if params[:dispFlag].present? then
      @dispFlag = params[:dispFlag].to_i
    else
      @dispFlag = 1
    end

    case @dispFlag
    when 0 then
      @list = Jewel.all.order(:date)
    when 2 then
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
