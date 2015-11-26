desc "This task is called by the Heroku scheduler add-on. It deletes ParkedMeters that have expired."
task :reset_expired_parked_meters => :environment do 
	users = User.all
	users.each { |u| u.reset_parked_meter }
end