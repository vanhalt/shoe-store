require 'faye/websocket'
require 'eventmachine'
require 'json'

require 'redis'

# This file listens to the inventory events and alert for LOW or HIGH stock

@redis = Redis.new

# adds store:model to redis SET for low stock
def alert_low_stock!(store, model)
  @redis.sadd 'low_stock', "#{store}:#{model}"
end

# adds store:model to redis SET for high stock
def alert_high_stock!(store, model)
  @redis.sadd 'high_stock', "#{store}:#{model}"
end

# Notifies if the current inventory is low or high
def alert!(store, model, inventory)
  low_stock = 10
  high_stock = 90

  if inventory <= low_stock
    alert_low_stock!(store, model)
    puts "Notified low stock for: #{store} #{model}"
  elsif inventory >= high_stock
    alert_high_stock!(store, model)
    puts "Notified high stock for: #{store} #{model}"
  end
end

EM.run {
  @redis.subscribe('inventory') do |on|
    on.subscribe do |channel, subscriptions|
      puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
    end
    on.message do |channel, msg|
      store, model, inventory = msg.split(':')

      alert! store, model, inventory.to_i
    end
 end
}