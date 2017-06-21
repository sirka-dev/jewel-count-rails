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
    logger.debug "DBに入れる"
    logger.debug "  count:" + params["count"]
    logger.debug "  time:" + Time.now.to_s(:db)
    logger.debug "  zonetime" + Time.zone.now.to_s(:db)
    logger.debug "  usage:" + params["usage"]

    jewel = Jewel.new( count: params["count"], date: Time.now.to_s(:db), usage: params['usage'] )
    jewel.save

    redirect_to :root
  end

  def filter
    if params[:filter].present? then
      session[:filter] = true
      session[:dispFlag] = params[:filter][:dispFlag]
      session[:usageFlag] = params[:filter][:usageFlag]
      session[:eventCheck] = params[:filter][:eventCheck]
      session[:event] = params[:filter][:event]
      session[:start_date] = params[:filter][:start_date]
      session[:end_date] = params[:filter][:end_date]

      # printSession()
    end

    redirect_to :root
  end

  def clear
    logger.debug "クリアー"
    reset_session
    redirect_to :root
  end

  def setParams()
    # とりあえず初期値を代入
    @dispOption = Settings.dispOption.map{|key,value| value}
    @usageOption = Settings.usage.map{|key,value| value}
    @eventOption = Event.order("start_date DESC").pluck(:name)

    if session[:filter].blank? then
      session[:dispFlag] = Settings.dispOption.all
      session[:usageFlag] = Settings.usage.all
      session[:eventCheck] = "true"
      session[:event] = Event.pluck(:name).last
    end

    @dispFlag = session[:dispFlag]
    @usageFlag = session[:usageFlag]
    @event = session[:event]

    # eventCheckのチェック有無により、イベントから開始終了日を決定
    if session[:eventCheck] == "true" then
      logger.debug "イベントチェック = true"
      @eventCheck = true
      @event = session[:event]
      eventTerm = Event.term( @event )
      @startDate = eventTerm["start_date"].strftime("%Y-%m-%d")
      @endDate = eventTerm["end_date"].strftime("%Y-%m-%d")
    else
      @eventCheck = false
      @startDate = session[:start_date]
      @endDate = session[:end_date]
    end

    # debugParam()
    # printSession()
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

  def printSession()
    logger.debug "---printSession---"
    logger.debug "session[:filter]     : " + session[:filter].to_s
    logger.debug "session[:dispFlag]   : " + session[:dispFlag].to_s
    logger.debug "session[:usageFlag]  : " + session[:usageFlag].to_s
    logger.debug "session[:eventCheck] : " + session[:eventCheck].to_s
    logger.debug "session[:event]      : " + session[:event].to_s
    logger.debug "session[:start_date] : " + session[:start_date]
    logger.debug "session[:end_date]   : " + session[:end_date]
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
        @list = Jewel.all.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").limit(20).to_a
      when Settings.dispOption.deleted_only then
        @list = Jewel.disable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").limit(20).to_a
      else
        @list = Jewel.enable.usage(@usageFlag).date_between( @startDate, @endDate).order("date DESC").limit(20).to_a
      end
    # end
  end
end
