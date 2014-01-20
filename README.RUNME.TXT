

How to run this software:

Install rabbitmq and mysql

Create the data directory with

    sudo mkdir /data
    sudo chown $(whoami) /data

Create the databases with

    script/create_databases.sh

Start rabbitmq with

    rabbitmq-server

