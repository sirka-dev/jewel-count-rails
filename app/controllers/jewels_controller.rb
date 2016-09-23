class JewelsController < ApplicationController
  def index
    logger.debug params[:dispFlag]

    @count = Count.all.order(:count)

    @jewel_sum = Jewel.where(delflag: false).sum(:count)

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
    Jewel.where(id: params[:id]).update( delflag: false )
    redirect_to :action => :index, :dispFlag => params[:dispFlag]
  end

  def delete
    Jewel.where(id: params[:id]).update( delflag: true )
    redirect_to :action => :index, :dispFlag => params[:dispFlag]
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
