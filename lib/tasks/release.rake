
desc 'Provision dev with prod data and start migration.'
task :prepare_dev_from_stage do
  heroku 'pg:backups:capture --app dmw-staging'
  backup_url = heroku 'pg:backups:url --app dmw-staging | cat'
  puts "Backup file can be found under: #{backup_url}"

  heroku "pg:backups:restore '#{backup_url}' DATABASE --app dmw-development  --confirm dmw-development"
  heroku 'run rake db:migrate --app dmw-development'
end


# (prepare heroku to have pipeline tools) heroku plugins:install heroku-pipelines
desc 'Release the currently staged version to prod incl. migration'
task :release_from_stage do
  heroku 'pg:backups:capture --app dmw'
  heroku 'pipelines:promote --app dmw-staging'
  heroku 'run rake db:migrate --app dmw'
end

# Executes a command in the Heroku Toolbelt
def heroku(command)
  Bundler.with_clean_env do
    output = %x[heroku #{command}]
    $?.success? or abort "heroku command failed! #{command}"
    return output
  end
end
