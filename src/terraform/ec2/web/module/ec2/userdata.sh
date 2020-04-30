#!/bin/bash
LOG=/var/log/user-data.log

touch $LOG
chmod 777 $LOG
echo "START userdata script." >> $LOG
su - app-user -c 'cd /home/app-user/www/app && bundle exec rake assets:precompile RAILS_ENV=production'
echo "END userdata script." >> $LOG
