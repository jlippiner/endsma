
namespace :production do
  desc "Push to Joyent production environment"
  task :deploy do
    ssh_command = "ssh hih_joyent"
    user        = "hihadmin"
    branch      = "master"
    revision    = ENV["revision"] || "HEAD"
    application = "endsma"
    env         = "production"
    port        = "10060"

    puts "updating application"
    %x{#{ssh_command} "cd ~/sites/#{application}/#{env} && git checkout master && git pull origin master"}

    puts "linking database.yml"
    %x{#{ssh_command} "ln -nfs ~/sites/#{application}/shared/config/database_#{env}.yml ~/sites/#{application}/#{env}/config/database.yml"}

    puts "linking log directory"
    %x{#{ssh_command} "ln -nfs ~/sites/#{application}/shared/log ~/sites/#{application}/#{env}/log"}

    puts "running rake db:migrate"
    %x{#{ssh_command} "cd ~/sites/#{application}/#{env} && rake db:migrate RAILS_ENV=#{env}"}

    puts "stopping mongrel"
    %x{#{ssh_command} "/usr/local/bin/mongrel_rails stop -P /users/home/hihadmin/var/run/mongrel-#{application}_#{env}-#{port}.pid"}

    puts "starting mongrel"
    %x{#{ssh_command} "/usr/local/bin/mongrel_rails start -c /users/home/hihadmin/sites/#{application}/#{env} -p #{port} -d -e #{env} -a 127.0.0.1 -P /users/home/hihadmin/var/run/mongrel-#{application}_#{env}-#{port}.pid"}

    puts "stopping mongrel for petitiontocuresma"
    %x{#{ssh_command} "/usr/local/bin/mongrel_rails stop -P /users/home/hihadmin/var/run/mongrel-petitiontocuresma_production-10061.pid"}
    
    puts "starting mongrel for petitiontocuresma"
    %x{#{ssh_command} "/usr/local/bin/mongrel_rails start -c /users/home/hihadmin/sites/endsma/production -p 10061 -d -e production -a 127.0.0.1 -P /users/home/hihadmin/var/run/mongrel-petitiontocuresma_production-10061.pid"}
  end
end

