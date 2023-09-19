#!/bin/bash

echo turning all lights off
curl http://localhost:3888/off
curl 'http://living-room-tv/sony/system' -H 'Connection: keep-alive' -H 'X-Auth-PSK: 2019' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS Xe Gecko) Chrome/80.0.3987.149 Safari/537.36' -H 'Content-Type: text/plain;charset=UTF-8' -H 'Accept: */*' -H 'Origin: null' -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' --data-binary '{"method":"setPowerStatus","version":"1.0","id":1,"params":[{"status":false}]}' --compressed --insecure
