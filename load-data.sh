#!/bin/bash
APP_URL=http://localhost:5000/
#APP_URL=https://peaceful-castle-8566.herokuapp.com/
jq -c '.[]|{"raw_battle_data": .}' <~/data.json | while read p; do 
curl -D- -o/dev/null -sS -HContent-Type:application/json -XPOST "$APP_URL/raw_battles" --data-binary "$p" </dev/null; done
