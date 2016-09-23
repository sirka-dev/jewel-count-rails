class JewelsController < ApplicationController
  def index
    logger.debug params[:dispFlag]

    @count = Count.all.order(:count)

    getJewelSum()

    @minDate = Jewel.minimum(:date).strftime("%Y-%m-%d")
    logger.debug @minDate

    @dispOption = { "デフォルト" => 1, "削除済み含む" => 0, "削除済みのみ" => 2 }
    if params[:dispFlag].present? then
      @dispFlag = params[:dispFlag].to_i
    else
      @dispFlag = 1
    end

    @usageOption = [ "全部", "ライブ", "ガチャ" ]
    if params[:usageFlag].present? then
      @usageFlag = params[:usageFlag]
    else
      @usageFlag = "全部"
    end

    case @dispFlag
    when 0 then
      @list = Jewel.all.usage(@usageFlag).order("date DESC")
    when 2 then
      @list = Jewel.where(delflag: true).usage(@usageFlag).order("date DESC")
    else
      @list = Jewel.where(delflag: false).usage(@usageFlag).order("date DESC")
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

  def getJewelSum
    if params[:start_date].present? then
      @jewel_sum = Jewel.where(delflag: false).where(date: (params[:start_date])..(Time.now)).sum(:count)
    else
      @jewel_sum = Jewel.where(delflag: false).sum(:count)
    end
  end
end
