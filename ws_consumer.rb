require 'faye/websocket'
require 'eventmachine'
require 'json'

# For StockEmitter
require 'redis'

# Class that takes a stock hash and emits information to redis
class StockEmitter

  def initialize
    @redis = Redis.new
  end
  
  def emit!(hsh)
    save_stock(hsh)
    save_store(hsh[:store])
    publish_stock(hsh)

    hsh
  end

  private

    # Creates a redis Hash to save the store name with the shoe model and its inventory
    def save_stock(stock)
      store_name = formatted_store_name(stock[:store])

      @redis.hset store_name, stock[:model], stock[:inventory]
    end

    # Adds the store name into a redis SET so we can have a list of the available stores
    def save_store(store_name)
      name = formatted_store_name(store_name)

      @redis.sadd :store_names, name
    end

    # Publishes stock updates about a store:model to a redis CHANNEL
    def publish_stock(stock)
      store = formatted_store_name(stock[:store])
      model = stock[:model]
      inventory = stock[:inventory]

      @redis.publish "inventory", "#{store}:#{model}:#{inventory}"
    end

    # formats the store name from "Store Name" to "Store_Name"
    def formatted_store_name(store_name)
      store_name.gsub ' ', '_'
    end
end

EM.run {
  ws = Faye::WebSocket::Client.new('ws://localhost:8081/')

  ws.on :message do |event|
    hsh = JSON.parse(event.data, symbolize_names: true)
    stock_emitter = StockEmitter.new

    puts "Consumed: #{stock_emitter.emit!(hsh)}"
  end
}