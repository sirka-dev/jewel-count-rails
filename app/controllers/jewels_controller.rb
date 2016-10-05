class JewelsController < ApplicationController
  def index
    @dispOption = Settings.dispOption.map{|key,value| value}
    @usageOption = Settings.usage.map{|key,value| value}
    @eventOption = Event.select(:name).all
    @dispFlag = Settings.dispOption.all
    @usageFlag = Settings.usage.all
    @eventFlag = Event.select(:name).first
    @startDate = Jewel.minDate
    @endDate = Date.today.to_s

    if params[:filter].present? then
      if params[:filter][:dispFlag].present? then
        @dispFlag = params[:filter][:dispFlag]
      end

      if params[:filter][:usageFlag].present? then
        @usageFlag = params[:filter][:usageFlag]
      end

      if params[:filter][:eventCheck] == "true" then
        event = Event.term(params[:filter][:event])
        @startDate = event["start_date"].strftime("%Y-%m-%d %H:%M:%S")
        @endDate = event["end_date"].strftime("%Y-%m-%d %H:%M:%S")
        @eventFlag = Event.where(name: params[:filter][:event]).select("name").first
        @usageFlag = Settings.usage.live
        logger.debug @usageFlag
      else
        if params[:filter][:start_date].present? then
          @startDate = params[:filter][:start_date]
        end

        if params[:filter][:end_date].present? then
          @endDate = params[:filter][:end_date]
        end
      end
    end

    getJewelSum()
    getJewelList()

    @graph = {}
    sum = 0
    @list.reverse.each { |record|
      sum += record[:count]
      @graph.store( record[:date], sum )
    }
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

  def getJewelSum()
    case @dispFlag
    when Settings.dispOption.contain_deleted then
      @jewel_sum = Jewel.all.usage(@usageFlag).date_between( @startDate, @endDate).sum(:count)
    when Settings.dispOption.deleted_only then
      @jewel_sum = Jewel.disable.usage(@usageFlag).date_between( @startDate, @endDate).sum(:count)
    else
      @jewel_sum = Jewel.enable.usage(@usageFlag).date_between( @startDate, @endDate).sum(:count)
    end
  end

  def getJewelList()
    case @dispFlag
    when Settings.dispOption.contain_deleted then
      @list = Jewel.all.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC")
    when Settings.dispOption.deleted_only then
      @list = Jewel.disable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC")
    else
      @list = Jewel.enable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC")
    end
  end
end
