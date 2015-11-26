# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
vanessa = User.create(first_name: 'Vanessa', last_name: 'Wan', email: 'vanessa@email.com', password: 'vanessa123', password_confirmation: 'vanessa123', role: 'admin')
p = ParkedMeter.create(user: vanessa)
vanessa.parked_meter = p
vanessa.save