require 'ds/cart/error'

module Ds
  module Cart

  class Api < Ds::Cart::Base

    def self.method_missing(method_name, *args)
      url = 'api/' + method_name.to_s.gsub('_', '/')
      request = {}
      args[0].each do |param, value|
        request[param.to_s.camelize] = value
      end
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        else raise InternalError
      end
    end

    def self.get_cart_summary(user_id)
      url = 'api/items/summary'
      request = { userId: user_id}
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        else raise InternalError
      end
    end


    def self.get_cart_items(user_id)
      url = 'api/items'
      request = { userId: user_id }
      response = Ds::Cart::Query.execute(url, request: request, method: :get)
      case response[:code]
        when 200 then JSON.parse(response[:body])
        else raise InternalError
      end
    end

    def self.add_to_cart(offering, article_url)
      url = 'api/products'
      request = {
          Offering: nil,
          SerializedOffering: offering.to_json,
          ArticleUrl: article_url,
          ArticleId: nil
        }
      response = Ds::Cart::Query.execute(url, request: request, method: :post)
      case response[:code]
        when 201 then JSON.parse(response[:body])
        when 500 then raise InternalError, JSON.parse(response[:body])["ErrorMessage"]
        else raise InternalError
      end
    end

  end

  end
end
