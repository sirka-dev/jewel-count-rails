# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

config = ActiveRecord::Base.configurations[::Rails.env]
ActiveRecord::Base.establish_connection
case config["adapter"]
  when "mysql", "postgresql"
    Event.connection.execute("truncate table events;")
  when "sqlite", "sqlite3"
    Event.connection.execute("delete from events;")
    Event.connection.execute("delete from sqlite_sequence where name = 'events';")
    Event.connection.execute("vacuum")
end

Event.create(name:"ラブレター", category:"アタポン形式", start_date:"2016-09-20 15:00:00", end_date:"2016-09-26 20:59:59")
Event.create(name:"LIVE Parade 201609", category:"Parade形式", start_date:"2016-09-30 15:00:00", end_date:"2016-10-08 20:59:59")
Event.create(name:"Jet to the Future", category:"アタポン形式", start_date:"2016-10-20 15:00:00", end_date:"2016-10-27 20:59:59")
Event.create(name:"LIVE Groove Dance burst 201610", category:"Groove形式", start_date:"2016-10-31 15:00:00", end_date:"2016-11-08 20:59:59")
Event.create(name:"Flip Flop", category:"アタポン形式", start_date:"2016-11-19 15:00:00", end_date:"2016-11-27 20:59:59")
Event.create(name:"Lunatic Show", category:"アタポン形式", start_date:"2017/01/20 15:00:00", end_date:"2017/01/27 20:59:59")
Event.create(name:"LIVE Parade 201701", category:"Parade形式", start_date: "2017/01/31 15:00:00", end_date: "2017/02/07 20:59:59")
Event.create(name:"情熱ファンファンファーレ", category:"アタポン形式", start_date:"2017/02/17 15:00:00", end_date:"2017/02/25 20:59:59")
