#!/bin/bash
set -x

DEFAULT_DEBUG=${DEFAULT_DEBUG:-false}

sed -i "s/INDEXER_HOST/${INDEXER_HOST}/; \
       s/INDEXER_USERNAME/${INDEXER_USERNAME}/; \
       s/INDEXER_PASSWORD/${INDEXER_PASSWORD}/; \
       s/DEFAULT_DEBUG/${DEFAULT_DEBUG}/; \
       s/STORAGE_HOST/${STORAGE_HOST}/; \
       s/STORAGE_USERNAME/${STORAGE_USERNAME}/; \
       s/COORDINATOR_HOST/${COORDINATOR_HOST}/; \
       s/STORAGE_PASSWORD/${STORAGE_PASSWORD}/" /etc/gnocchi/gnocchi.conf

echo "" >> /etc/apache2/ports.conf

gnocchi-upgrade

apache2ctl start

fake_id=d4fea86607994341975098cdc6cc605b
cat<<EOF >openrc
export OS_AUTH_TYPE=gnocchi-noauth
export GNOCCHI_USER_ID=${fake_id}
export GNOCCHI_PROJECT_ID=${fake_id}
export GNOCCHI_ENDPOINT=http://127.0.0.1:8041
EOF

source openrc

gnocchi --gnocchi-endpoint ${GNOCCHI_ENDPOINT} archive-policy create -d granularity:5m,points:12 -d granularity:1h,points:24 -d granularity:1d,points:30 low
gnocchi --gnocchi-endpoint ${GNOCCHI_ENDPOINT} archive-policy create -d granularity:60s,points:60 -d granularity:1h,points:168 -d granularity:1d,points:365 medium
gnocchi --gnocchi-endpoint ${GNOCCHI_ENDPOINT} archive-policy create -d granularity:1s,points:86400 -d granularity:1m,points:43200 -d granularity:1h,points:8760 high
gnocchi --gnocchi-endpoint ${GNOCCHI_ENDPOINT} archive-policy-rule create -a low -m "*" default

apache2ctl stop
sleep 5

exec "$@"
