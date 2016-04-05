module Bittrex
  class Orderbook
    attr_reader :market, :buy, :sell, :raw

    def initialize(market, attrs = {})
      @market = market
      @buy = []
      attrs['buy'].each do |b|
          @buy << { quantity: b['Quantity'], rate: b['Rate'] }
      end
      @sell = []
      attrs['sell'].each do |s|
          @sell << { quantity: s['Quantity'], rate: s['Rate'] }
      end
      @raw = attrs
    end

    # Example:
    # Bittrex::Orderbook.current('BTC-HPY')
    def self.current(market, type = 'both')
      new(market, client.get('public/getorderbook', {market: market, type: type}))
    end

    private

    def self.client
      @client ||= Bittrex.client
    end
  end
end
