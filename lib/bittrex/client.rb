require 'faraday'
require 'base64'

module Bittrex
  class Client
    HOST = 'https://bittrex.com/api/v1.1'

    attr_reader :key, :secret

    def initialize(attrs = {})
      @key    = attrs[:key]
      @secret = attrs[:secret]
    end

    def get(path, params = {}, headers = {})
      nonce = Time.now.to_i
      response = connection.get do |req|
        url = "#{HOST}/#{path}"
        req.params.merge!(params)
        
        if key
          req.params[:apikey]   = key
          req.params[:nonce]    = nonce
          req.headers[:apisign] = signature(url, nonce, req.params)
        end

        req.url(url)
      end
      
      parsed_answer = JSON.parse(response.body)
      
      if parsed_answer['success'] 
        parsed_answer['result']
      else
        parsed_answer['message']
      end
    end

    private

    def signature(url, nonce, params)
      OpenSSL::HMAC.hexdigest('sha512', secret, "#{url}?#{params.to_query}")
    end

    def connection
      @connection ||= Faraday.new(:url => HOST) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
