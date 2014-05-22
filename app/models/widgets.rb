class Widgets < ActiveRecord::Base

  scope :last_active, -> { where(widget_type: 'purchase', status: 'chated').order("created_at DESC") }

  def cart
    @cart ||= begin
      summary = Ds::Cart::Api.get_cart_summary(client_integration_id)

      product_info = Ds::Cart::Api.get_product(products)
      {
        count: summary['Count'],
        product: product_info['Product'],
        order: product_info.except!('Product', 'SerializedProduct'),
        item: Ds::Cart::Api.get_cart_item(product_info['CartItemId'])
      }
    end
  end

  def order_offerings
    JSON.parse(offerings)
  end

  def order_products
    @order_products ||= begin
      result = []
      order_offerings.each do |offering_id, offering_price_id|
        product = Products.new(offering_id)
        result << {
            offering: product.offering,
            price: product.price(offering_price_id)
          }
      end
      result
    end
  end

  def order
    @order ||= Ds::Cart::Api.get_order(order_id)
  end

end
