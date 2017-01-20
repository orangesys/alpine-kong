#!/bin/bash

set +ex

curl -si -X POST \
  --url http://localhost:8001/apis/ \
  --data 'name=mockbin' \
  --data 'upstream_url=http://mockbin.com/' \
  --data 'request_host=mockbin.com'

curl -si -X POST \
  --url http://localhost:8001/apis/mockbin/plugins/ \
  --data 'name=jwt'

curl -si -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=mockbin"


curl -si -X POST \
   --url http://localhost:8001/consumers/mockbin/jwt \
   --data 'key=a36c3049b36249a3c9f8891cb127243c' \
   --data 'secret=e71829c351aa4242c2719cbfbe671c09'

curl -s http://localhost:8000/request?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4 --header "Host: mockbin.com"
curl -s http://localhost:8000/request?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhMzZjMzA0OWIzNjI0OWEzYzlmODg5MWNiMTI3MjQzYyIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.AhumfY35GFLuEEjrOXiaADo7Ae6gt_8VLwX7qffhQN4 --header "Host: mockbin.com"|grep -q GET
