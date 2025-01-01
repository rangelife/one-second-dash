#!/bin/bash -e

curl -X POST "http://homeassistant.local:8123/api/webhook/$1"
