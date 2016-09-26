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
    logger.debug "  zonetime" + Time.zone.now.to_s(:db)
    logger.debug "  usage:" + params["usage"]

    jewel = Jewel.new( count: params["count"], date: Time.now.to_s(:db), usage: params['usage'] )
    jewel.save

    redirect_to :root
  end

  def getJewelSum
    logger.debug "start_date : " + params["start_date"] if params[:start_date].present?
    logger.debug "end_date : " + params["end_date"] if params[:end_date].present?

    if params["start_date"].present? then
      start_date = params["start_date"].in_time_zone
      end_date = params["end_date"].in_time_zone

      logger.debug "conv start_date : " + start_date.to_s
      logger.debug "conv end_date : " + end_date.to_s

      # @jewel_sum = Jewel.where(delflag: false).where("date >= ?", start_date).where("date <= ?", end_date).sum(:count)
      @jewel_sum = Jewel.where(delflag: false).where(date: start_date..end_date).sum(:count)
    else
      @jewel_sum = Jewel.where(delflag: false).sum(:count)
    end
  end
end
