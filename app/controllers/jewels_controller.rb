class JewelsController < ApplicationController
  def index
    setParams()
    getJewelSum()
    getJewelList()

    @graph = {}
    @graph.store( @startDate, 0 )
    sum = 0
    @list.reverse.each { |record|
      sum += record[:count]
      @graph.store( record[:date] - 9.hour, sum )
    }
    @graph.store( @endDate + "14:59:59", sum )
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

  def setParams()
    # とりあえず初期値を代入
    @dispOption = Settings.dispOption.map{|key,value| value}
    @dispFlag = Settings.dispOption.all
    @usageOption = Settings.usage.map{|key,value| value}
    @usageFlag = Settings.usage.all
    @eventCheck = false
    @eventOption = Event.order("start_date DESC").pluck(:name)
    @event = Event.pluck(:name).last
    @startDate = Jewel.minDate
    @endDate = Date.today.to_s

    # formとsessionの値から変数値を代入
    if session[:eventCheck].present?
      @eventCheck = session[:eventCheck]
      @event = session[:event] if session[:event].present?
      eventTerm = Event.term( @event )
      @startDate = eventTerm["start_date"].strftime("%Y-%m-%d")
      @endDate = eventTerm["end_date"].strftime("%Y-%m-%d")
    end

    if params[:filter].present? then
      if params[:filter][:dispFlag].present? then
        @dispFlag = params[:filter][:dispFlag]
      end

      if params[:filter][:usageFlag].present? then
        @usageFlag = params[:filter][:usageFlag]
      end

      if params[:filter][:eventCheck] then
        event = Event.term(params[:filter][:event])
        @startDate = event["start_date"].strftime("%Y-%m-%d")
        @endDate = event["end_date"].strftime("%Y-%m-%d")
        @eventCheck = params[:filter][:eventCheck]
        session[:eventCheck] = params[:filter][:eventCheck]
        @event = params[:filter][:event]
        session[:event] = @event
        @usageFlag = Settings.usage.live
      else
        session[:eventCheck] = false
        session[:event] = nil

        if params[:filter][:start_date].present? then
          @startDate = params[:filter][:start_date]
        end

        if params[:filter][:end_date].present? then
          @endDate = params[:filter][:end_date]
        end
      end
    end

    # debugParam()
    # printSesion()
  end

  def debugParam()
    logger.debug "---debugParam---"
    logger.debug "@dispOption  : " + @dispOption.to_s
    logger.debug "@dispFlag    : " + @dispFlag.to_s
    logger.debug "@usageOption : " + @usageOption.to_s
    logger.debug "@usageFlag   : " + @usageFlag.to_s
    logger.debug "@eventCheck  : " + @eventCheck.to_s
    logger.debug "@eventOption : " + @eventOption.to_s
    logger.debug "@event       : " + @event.to_s
    logger.debug "@startDate   : " + @startDate.to_s
    logger.debug "@endDate     : " + @endDate.to_s
    logger.debug "---debugParam---"
  end

  def printSesion()
    logger.debug "---printSession---"
    logger.debug "session[:eventCheck] : " + session[:eventCheck].to_s if session[:eventCheck] != nil
    logger.debug "session[:event]      : " + session[:event].to_s if session[:event] != nil
    logger.debug "---printSession---"
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
      @list = Jewel.all.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").to_a
    when Settings.dispOption.deleted_only then
      @list = Jewel.disable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").to_a
    else
      @list = Jewel.enable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").to_a
    end
  end
end
