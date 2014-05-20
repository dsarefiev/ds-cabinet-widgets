class Widgets < ActiveRecord::Base

  scope :last_active, -> { where(widget_type: 'purchase', status: 'chated').order("created_at DESC") }

  def cart
    @cart ||= begin
      product_info = Ds::Cart::Api.get_product(products)
      summary = Ds::Cart::Api.get_cart_summary(client_siebel_id)
      {
        count: summary['Count'],
        product: product_info['Product'],
        order: product_info.except!('Product', 'SerializedProduct'),
        item: Ds::Cart::Api.get_cart_item(product_info['CartItemId'])
      }
    end
  end

  def cart_products
    Ds::Cart::Api.get_product(products)
  end

  def cart_info
    {
      items: Ds::Cart::Api.get_cart_items(client_siebel_id),
      products: Ds::Cart::Api.get_product(products)
    }
  end

end
