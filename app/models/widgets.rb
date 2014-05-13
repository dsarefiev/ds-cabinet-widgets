class Widgets < ActiveRecord::Base

  def cart
    @cart ||= begin
      summary = Ds::Cart::Api.get_cart_summary(client_siebel_id)
      {
        count: summary['Count'],
        items: Ds::Cart::Api.get_cart_items(client_siebel_id)
      }
    end
  end

end
