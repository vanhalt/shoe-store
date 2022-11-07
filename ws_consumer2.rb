require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'faraday'

EM.run {
  ws = Faye::WebSocket::Client.new('ws://localhost:8081/')

  ws.on :message do |event|
    hsh = JSON.parse(event.data, symbolize_names: true)

    url = 'http://localhost:3000/transactions'
    response = Faraday.post(url, {transaction: hsh})

    puts response.body
  end
}