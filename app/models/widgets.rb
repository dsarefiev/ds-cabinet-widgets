class Widgets < ActiveRecord::Base

  def cart
    @cart ||= {
      summary: Ds::Cart::Api.get_cart_summary(client_siebel_id),
      items: Ds::Cart::Api.get_cart_items(client_siebel_id)
    }
  end

end
