require 'sinatra'
require 'sinatra/json'
require 'redis'

STORES = :store_names
LOW_STOCK = :low_stock
HIGH_STOCK = :high_stock


before do
  @redis = Redis.new
  content_type :json
end

# get the list of available stores
get '/stores' do
  json @redis.smembers STORES 
end

# get models from a store
get '/stores/:store' do
  store = params[:store]

  json @redis.hkeys store 
end

# get the inventory of a specific model
get '/stores/:store/models/:model' do
  store = params[:store]
  model = params[:model]
  
  response = { inventory: @redis.hget(store, model).to_i }

  json response
end

# get full inventory. Used for React frontend
get '/inventory' do
  headers \
  'Access-Control-Allow-Origin' => '*'

  stores = @redis.smembers STORES
  response = []

  stores.each do |store|
    hsh = {name: store, models: []}

    models = @redis.hkeys store

    models.each do |model|
      d = {name: model, inventory: @redis.hget(store, model).to_i}
      hsh[:models].push d
    end

    response.push hsh
  end

  json response
end

# get the list of low stock models in stores
get '/low_stock' do
  stock = @redis.smembers LOW_STOCK
  json format_stocks(stock)
end

# get the list of high stock models in stores
get '/high_stock' do
  stock = @redis.smembers HIGH_STOCK
  json format_stocks(stock)
end

## Helper methods

def format_stocks(stock)
  formatted_stock = Hash.new { |h, k| h[k] = [] }

  stock.each do |data|
    store, model = data.split ':'
    formatted_stock[store].push model
  end

  formatted_stock
end