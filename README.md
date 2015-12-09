# BC-EC gnocchi project

## Usage
### step1
start mysql container, aka. docker-compose run -d indexer

### step2
create a database in indexer, named `gnocchi`
use command `docker ps` and `docker inspect container-id` to find out the mysql 
ip, and mysql -uroot -p123345 -hmysql-host "create database gnocchi";

### step3
start gnocchi service

	docker-compose run -d --service-ports indexer
	docker-compose run -d --service-ports storage
	docker-compose run -d --service-ports gnocchi-api
	docker-compose run -d --service-ports gnocchi-metric

### step4 
test, setup keystone service

	$ gnocchi archive-policy create -d granularity:5m,points:12 -d granularity:1h,points:24 -d granularity:1d,points:30 low
	$ gnocchi archive-policy create -d granularity:60s,points:60 -d granularity:1h,points:168 -d granularity:1d,points:365 medium
	$ gnocchi archive-policy create -d granularity:1s,points:86400 -d granularity:1m,points:43200 -d granularity:1h,points:8760 high
	$ gnocchi archive-policy-rule create -a low -m "*" default


## Advanced

### source code
gnocchi: `git clone https://github.com/openstack/gnocchi` 
python-gnocchiclient: `git clone https://github.com/openstack/python-gnocchiclient` 

### (re)build docker image
cd influxdb; docker build -t bcec/influxdb:v0.1 .
cd gnocchi; docker build -t bcec/gnocchi:v0.1 .

## TODO
### memcahced: improve api work performance(no more needed!!!)
### zookeeper: distribute all componants(impl)
### wsgi: imporve api worker performance
