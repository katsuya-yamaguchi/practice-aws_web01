#!/bin/bash
LOG=/var/log/user-data.log

touch $LOG
chmod 777 $LOG
echo "START userdata script." >> $LOG
su - app-user -c 'cd /home/app-user/www/app && bundle exec rake assets:precompile'
su - app-user -c 'cd /home/app-user/www/app && bundle exec rails db:migrate && puma -t 5:5 -p 80 -c config/puma.rb'
echo "END userdata script." >> $LOG
