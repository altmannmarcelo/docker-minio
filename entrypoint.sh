#!/bin/sh

_MINIO_ROOT_USER=admin
_MINIO_ROOT_PASSWORD=password
_MINIO_PORT=9000
if [ ! -z "$USER" ]; then
    _MINIO_ROOT_USER=$USER
fi
if [ ! -z "$PASSWORD" ]; then
    _MINIO_ROOT_PASSWORD=$PASSWORD
fi
if [ ! -z "$PORT" ]; then
    _MINIO_PORT=$PORT
fi
MINIO_ROOT_USER=${_MINIO_ROOT_USER} MINIO_ROOT_PASSWORD=${_MINIO_ROOT_PASSWORD} minio server --address :${_MINIO_PORT} /mnt/data