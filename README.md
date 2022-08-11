# Minio docker container

## What is this container ?

This container was created to enable *integration testing* against s3 api.
It uses [minio](https://github.com/minio/minio "minio") service.

For convenience, the following commands are available in the container :

* aws cli
* iproute2 / tc
* dsniff / tcpkill
* curl
* jq

## How to use this container

### Docker Hub image
I start the container using the following command:


```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 9000:9000 --rm -p 9001:9001 --name s3 altmannmarcelo/minio:latest
```

You can edit some envoirement variables to configure your S3 service:
* `--env USER` - to change Access Key ID (Default: admin)
* `--env PASSWORD` - to change Secret Access Key (Default: password)
* `--env PORT` - to change the endpoint port (Default: 9000)

```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 9001:9001 --env USER=myuser --env PASSWORD=myStrongPassw0rd! --env PORT=9001 --name s3 altmannmarcelo/minio:latest
```

### Building local image

Build a local image using the Dockerfile

```
docker build .

. . .
Successfully built 5f1fd412b0e4

```

Then start the container passing the hash id from previous command

```
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 9000:9000 --name s3 5f1fd412b0e4
```

Alternatively, you can pass `-t your_user/image_name#tag` parameter to build command and use that as image ID:

```
docker build -t altmannmarcelo/minio:latest .
docker run -d --security-opt seccomp=unconfined --cap-add=NET_ADMIN --rm -p 9000:9000 --name s3 altmannmarcelo/minio:latest
```

## Sample aws commands

```
aws configure
AWS Access Key ID [None]: admin
AWS Secret Access Key [None]: password
Default region name [None]: us-east-1
Default output format [None]:

aws configure set default.s3.signature_version s3v4

# Create a bucket
aws --endpoint-url http://127.0.0.1:9000 s3 mb s3://newbucket

# Upload a file
echo "test" > test.txt
aws --endpoint-url http://127.0.0.1:9000  s3 cp test.txt s3://newbucket

# List files
aws --endpoint-url http://127.0.0.1:9000 s3 ls
```

## Chaos

To test how your application will behave under intermittent network issues either on your side or on the provider site you can use below commands

```
docker exec -it s3 bash


# Kill all connections from application
APP_HOST=172.17.0.1
timeout 5 tcpkill host ${APP_HOST}


# Add network latency

tc qdisc add dev eth0 root netem delay 90ms
sleep $[($RANDOM%10) + 1]s
tc qdisc del dev eth0 root netem;

# Damage communication by adding huge latency and packet loss

tc qdisc add dev eth0 root netem delay 60000ms loss 99%;
sleep $[($RANDOM%10) + 1]s
tc qdisc del dev eth0 root netem;
```
