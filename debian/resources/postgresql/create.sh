#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#includes
. ../config.sh

#set the working directory
cwd=$(pwd)
cd /tmp

#set client encoding
sudo -u postgres psql -p $database_port -c "SET client_encoding = 'UTF8';";

#add the database users and databases
sudo -u postgres psql -p $database_port -c "CREATE DATABASE fusionpbx;";
sudo -u postgres psql -p $database_port -c "CREATE DATABASE freeswitch;";

#add the users and grant permissions
sudo -u postgres psql -p $database_port -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$database_password';"
sudo -u postgres psql -p $database_port -c "CREATE ROLE freeswitch WITH LOGIN PASSWORD '$database_password';"
sudo -u postgres psql -p $database_port -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx;"
sudo -u postgres psql -p $database_port -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch TO freeswitch;"

#reload the config
sudo -u postgres psql -p $database_port -c "SELECT pg_reload_conf();"

#restart postgres
#systemctl restart postgresql
