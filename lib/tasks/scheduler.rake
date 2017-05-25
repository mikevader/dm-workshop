require 'date'

desc "This task is called by the Heroku scheduler add-on"
task :clear_old_sessions => :environment do
  threshold_date = threshold_date_string
  puts "Clear sessions older than #{threshold_date}..."
  sessions_tobe_cleared = count_old_sessions(threshold_date)
  delete_old_sessions(threshold_date)
  sessions_total = count_sessions
  puts "done [cleared: #{sessions_tobe_cleared}, remaining: #{(sessions_total)}]."
end


task :count_old_sessions => :environment do
  threshold_date = threshold_date_string

  puts "Count sessions older than #{threshold_date}..."
  old_sessions = count_old_sessions(threshold_date)
  puts "done: #{old_sessions}"
end

task :send_reminders => :environment do
  User.send_reminders
end


# @param threshold [Fixnum] days beyond which sessions are considered old
# @return [Fixnum] number of sessions beyond the threshold
def count_old_sessions(threshold)
  sql = "SELECT count(*) AS old_sessions"\
        " FROM sessions"\
        " WHERE updated_at < '#{threshold}';"
  result = ActiveRecord::Base.connection.execute(sql)

  result[0]['old_sessions']
end

# @return [Fixnum] number of sessions
def count_sessions
  sql = "SELECT count(*) AS sessions_total"\
        " FROM sessions;"
  result = ActiveRecord::Base.connection.execute(sql)

  result[0]['sessions_total']
end

# @param threshold [Fixnum] days beyond which sessions are considered old
# @return [Fixnum] number of deleted sessions
def delete_old_sessions(threshold)
  sql = "DELETE"\
        " FROM sessions"\
        " WHERE updated_at < '#{threshold}';"
  ActiveRecord::Base.connection.execute(sql)
end

def threshold_date_string(threshold_in_days = 30)
  threshold = Date.today - threshold_in_days
  threshold.strftime('%Y-%m-%d')
end