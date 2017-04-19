class EventsController < ApplicationController
  def index
    @categoryOption = Settings.category.map{|key,value| value}
    @category = Settings.category.atapon
  end

  def create
    if params["name"] != ""
      Event.create( name: params["name"], category: params["category"], start_date: params["start_date"] + ' 15:00:00', end_date: params["end_date"] + ' 20:59:59')
      redirect_to :controller => :events, :action => :index, :notice => "登録しました"
    else
      redirect_to :controller => :events, :action => :index, :notice => "イベント名が空欄かも？"
    end
  end
end
