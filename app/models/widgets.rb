class Widgets < ActiveRecord::Base

  scope :last_active, -> { where(widget_type: 'purchase', status: 'chated').order("created_at DESC") }

  def cart
    @cart ||= begin
      summary = Ds::Cart::Api.get_cart_summary(client_siebel_id)
      {
        count: summary['Count'],
        items: Ds::Cart::Api.get_cart_items(client_siebel_id)
      }
    end
  end

  def cart_products
    Ds::Cart::Api.get_product(products)
  end

end
