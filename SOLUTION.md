# Implementation
![Shoe Store Diagram](./show_store.png)

## requirements

- Docker
- Docker compose

## Versions

- nodejs: v18.12.0
- ruby: 3.1.1

## Starting the project

```bash
bundle install
docker-compose up # runs services
bundle exec foreman start # runs consumers/producers scripts
```

Later check the `api`, `analytics` and `web-dashboard` sections

## api
Sinatra based application with the following endpoints:

- '/stores'
- '/models'
- '/stores/:store'
- '/stores/:store/models/:model'
- '/inventory'
- '/low_stock'
- '/high_stock'

To run it:

```bash
cd api
bundle install

bundle exec ruby app.rb
```

## web-dashboard
React application that showcases a small dashboard with the inventory. It refreshes itself.

To run it:

```bash
nvm use # if you're using nvm
cd web-dashboard
npm install
npm start # requires de API to be runnning
```

## Analytics

Rails app with ActiveAdmin dashboard showing some analytics...

```bash
cd analytics
bundle install
bundle exec rails db:setup
bundle exec rails s # requires de postgresql DB to be runnning
```

## ws-consumer.rb
Consumes data from the WebSocket and emits information to Redis using the class `StockEmitter`
## ws-consumer2.rb
Consumes data from the WebSocket and emits information to the `/transactions` endpoint of the Analytics service

## stock_alerts_subscriber.rb
Maintains a set of high/low stock shoe models

## stock_checker_subscriber.rb
Checks for the shoe models that need to be removed from the high/low sets

### Notes

- The `docker-compose` file contains a redis and postgresql
- The `Gemfile` contains:
"faye-websocket"
"redis"
"foreman"
"faraday'


#### issues

- probably the naming convention used is not correct for the subscribers/consumer

- 127.0.0.1:6379> hset 25092464817701cd854acd09f1e41d5aa87b78a5c5ce38e8d3bf3e2e52a28218 hola 4
(error) WRONGTYPE Operation against a key holding the wrong kind of value

aparently redis doesn't accept hashes name that start with a number. Solved using store name separated with `_`