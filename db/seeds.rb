# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Event.create(name:"Lunatic Show", category:"アタポン形式", start_date:"2017/01/20 15:00:00", end_date:"2017/01/27 20:59:59")
Event.create(name:"LIVE Parade 201701", category:"Parade形式", start_date: "2017/01/31 15:00:00", end_date: "2017/02/07 20:59:59")
Event.create(name:"情熱ファンファンファーレ", category:"アタポン形式", start_date:"2017/02/17 15:00:00", end_date:"2017/02/25 20:59:59")
