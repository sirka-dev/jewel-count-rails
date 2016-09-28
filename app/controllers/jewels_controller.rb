class JewelsController < ApplicationController
  def index
    logger.debug params[:dispFlag]

    if params[:start_date].present? then
      @startDate = params[:start_date]
    else
      @startDate = Jewel.minDate
    end
    logger.debug @startDate

    if params[:end_date].present? then
      @endDate = params[:end_date]
    else
      @endDate = Date.today.to_s
    end
    logger.debug @endDate

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

    getJewelSum(@dispFlag, @usageFlag)
    getJewelList(@dispFlag, @usageFlag)
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
    logger.debug "  zonetime" + Time.zone.now.to_s(:db)
    logger.debug "  usage:" + params["usage"]

    jewel = Jewel.new( count: params["count"], date: Time.now.to_s(:db), usage: params['usage'] )
    jewel.save

    redirect_to :root
  end

  def getJewelSum( dispFlag, usageFlag )
    case dispFlag
    when Settings.dispOption.contain_deleted then
      @jewel_sum = Jewel.all.usage(usageFlag).date_between( @startDate, @endDate).sum(:count)
    when Settings.dispOption.deleted_only then
      @jewel_sum = Jewel.disable.usage(usageFlag).date_between( @startDate, @endDate).sum(:count)
    else
      @jewel_sum = Jewel.enable.usage(usageFlag).date_between( @startDate, @endDate).sum(:count)
    end
  end

  def getJewelList( dispFlag, usageFlag )
    case dispFlag
    when Settings.dispOption.contain_deleted then
      @list = Jewel.all.usage(usageFlag).date_between( @startDate, @endDate).order("date DESC")
    when Settings.dispOption.deleted_only then
      @list = Jewel.disable.usage(usageFlag).date_between( @startDate, @endDate).order("date DESC")
    else
      @list = Jewel.enable.usage(usageFlag).date_between( @startDate, @endDate).order("date DESC")
    end
  end
end
