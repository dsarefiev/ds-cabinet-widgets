require 'singleton'

#TODO

module Ds
  module Cart

  class Api < Ds::Cart::Base
    include Singleton

    def method_missing(method_name, *args)
      url = 'api/' + method_name.to_s.gsub('_', '/')
      request = {}
      args[0].each do |param, value|
        request[param.to_s.camelize] = value
      end
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

    def get_cart_summary(user_id, client_session_key)
      url = 'api/items/summary'
      request = { userId: user_id, clientSessionKey: client_session_key}
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end


    def get_cart_items(user_id)
      url = 'api/items'
      request = { userId: user_id }
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        when 400 then raise InvalidCredentials
        else raise InternalError
      end
    end

  end

  end
end
