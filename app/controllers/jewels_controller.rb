class JewelsController < ApplicationController
  def index
    logger.debug params[:dispFlag]

    getJewelSum()

    @minDate = Jewel.minimum(:date).strftime("%Y-%m-%d")
    logger.debug @minDate

    @dispOption = Settings.dispOption.map{|key,value| value}
    if params[:dispFlag].present? then
      @dispFlag = params[:dispFlag]
    else
      @dispFlag = Settings.dispOption.all
    end

    @usageOption = Settings.usage.map{|key,value| value}
    if params[:usageFlag].present? then
      @usageFlag = params[:usageFlag]
    else
      @usageFlag = Settings.usage.all
    end

    case @dispFlag
    when Settings.dispOption.contain_deleted then
      @list = Jewel.all.usage(@usageFlag).order("date DESC")
    when Settings.dispOption.deleted_only then
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
