#!/bin/sh

_MINIO_ROOT_USER=admin
_MINIO_ROOT_PASSWORD=password
_MINIO_PORT=9000
_MINIO_ADMIN_PORT=9001
if [ ! -z "$USER" ]; then
    _MINIO_ROOT_USER=$USER
fi
if [ ! -z "$PASSWORD" ]; then
    _MINIO_ROOT_PASSWORD=$PASSWORD
fi
if [ ! -z "$PORT" ]; then
    _MINIO_PORT=$PORT
fi
if [ ! -z "$ADMIN_PORT" ]; then
    _MINIO_ADMIN_PORT=$ADMIN_PORT
fi
MINIO_ROOT_USER=${_MINIO_ROOT_USER} MINIO_ROOT_PASSWORD=${_MINIO_ROOT_PASSWORD} minio server --address :${_MINIO_PORT} --console-address :${_MINIO_ADMIN_PORT} /mnt/data &
sleep 10
mc config host add s3 http://127.0.0.1:9000 admin password
mc admin user add s3 s3user backup123
mc admin policy attach s3 readwrite --user s3user
sleep infinity
