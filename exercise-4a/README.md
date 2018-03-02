# Exercise 4a - Envoy

### Run envoy locally using docker

Pull envoy images:

```sh
docker pull envoyproxy/envoy
docker pull tutum/curl
docker pull citizenstig/httpbin
```

If you have problems with docker the following commands are helpful:

View all running docker images and find the container id:
`docker ps -a`

Force remove a running docker image:
`docker rm -f #CONTAINER_ID`

Run httpbin and expose port 8000:

```sh
docker run -it --name httpbin -p 8000:8000 --rm citizenstig/httpbin
curl localhost:8000/headers
```


Run envoy using the sample config in guestbook directory.  

To share the config with docker you need to first open the docker preferences and add the guestbook directory.


```sh
docker run -it --rm envoyproxy/envoy envoy --help
docker run -it --name proxy --link httpbin \
  -p 15000:15000 -p 15001:15001 \
  -v $(pwd)/guestbook/simple.json:/etc/simple.json \
  envoyproxy/envoy envoy -c /etc/simple.json
```

curl the envoy proxy:

```sh
curl  -X GET http://localhost:15001/headers
```

Notice that Envoy added a X-Request-Id

Curl the envoy admin stats and then zero in on the retry count:

```sh
curl -X GET http://localhost:15000/stats
curl -X GET http://localhost:15000/stats | grep retry
```

In the simple json the retry policy for 5xx is set to:

"retry_policy": {
  "retry_on": "5xx",
  "num_retries": 3
}

If you trigger a 500 you can see the retry count go up:

```sh
curl -X GET http://localhost:15001/status/500
curl -X GET http://localhost:15001/status/500
curl -X GET http://localhost:15001/status/500
curl -X GET http://localhost:15001/status/500
curl -X GET http://localhost:15001/status/500
curl -X GET http://localhost:15000/stats | grep retry
```


#### [Continue to Exercise 5 - Installing Istio](../exercise-5/README.md)
