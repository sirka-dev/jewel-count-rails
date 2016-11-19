# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Event.Event.where(name: 'LIVE Groove Dance burst 201610').update(end_date: "2016/11/08 20:59:59")
Event.create(name:"Flip Flop", category:"アタポン形式", start_date: "2016/11/19 15:00:00", end_date: "2016/11/27 20:59:59")
