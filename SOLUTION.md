# Implementation

## api
Sinatra based application with the following endpoints:

- '/stores'
- '/stores/:store'
- '/stores/:store/models/:model'
- '/inventory'
- '/low_stock'
- '/high_stock'

## web-dashboard
React application that showcases a small dashboard with the inventory. It refreshes itself.

## ws-consumer.rb
Consumes data from the WebSocket and emits information to Redis using the class `StockEmitter`

## stock_alerts_subscriber.rb
Maintains a set of high/low stock shoe models

## stock_checker_subscriber.rb
Checks for the shoe models that need to be removed from the high/low sets

### Notes

- The `docker-compose` file contains a redis service
- The `Gemfile` contains:
"faye-websocket"
"redis"


#### issues

- probably the naming convention used is not correct for the subscribers/consumer

- 127.0.0.1:6379> hset 25092464817701cd854acd09f1e41d5aa87b78a5c5ce38e8d3bf3e2e52a28218 hola 4
(error) WRONGTYPE Operation against a key holding the wrong kind of value

aparently redis doesn't accept hashes name that start with a number. Solved using store name separated with `_`