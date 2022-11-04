require 'faye/websocket'
require 'eventmachine'
require 'json'

require 'redis'

# This file listens to the inventory events and remove models from LOW/HIGH stock redis SETs

@redis = Redis.new

# adds store:model to redis SET for low stock
def remove_from_alert_stocks!(store, model)
  @redis.srem 'low_stock', "#{store}:#{model}"
  @redis.srem 'high_stock', "#{store}:#{model}"
end

# Notifies if the current inventory is low or high
def check_stocks!(store, model, inventory)
  low_stock = 10
  high_stock = 90

  if inventory > low_stock && inventory < high_stock
    remove_from_alert_stocks!(store, model)
    puts "Removed from low/high stock: #{store} #{model}"
  end
end

EM.run {
  @redis.subscribe('inventory') do |on|
    on.subscribe do |channel, subscriptions|
      puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
    end
    on.message do |channel, msg|
      store, model, inventory = msg.split(':')

      check_stocks! store, model, inventory.to_i
    end
 end
}