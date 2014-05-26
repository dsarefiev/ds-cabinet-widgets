class Widgets < ActiveRecord::Base

  scope :last_active, -> { where(widget_type: 'purchase').order("created_at DESC") }

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

  def update_status_from_order
    order = Ds::Cart::Api.get_order(order_id)
    status = case Ds::Cart::Base.order_statuses[order['OrderStatus']]
      when 'PaymentSucess'
        'payment_sucess'
      when 'PaymentError'
        'payment_error'
      else
        false
    end
    update_attributes(:status, status) if status
  end

  def add_order(options = nil)
    offerings = []
    options['offerings'].each do |offering_id, offering_price_id|
      offerings << {
        Offering: {
          OfferingId: offering_id,
          OfferingPriceId: offering_price_id,
          Characteristics: [],
          ClientKey: options[:client_integration_id],
        },
        SerializedOffering: nil,
        ProductsForUpdate: nil,
        ArticleUrl: Rails.configuration.pim_product_url,
        ArticleId: nil,
        MerchantId: nil,
        Promocode: nil
      }
    end
    order_options = {
      UserId: options[:client_integration_id],
      Offerings: offerings,
      SuccessUrl: Rails.application.routes.url_helpers.purchase_pay_success_url(self),
      ErrorUrl: Rails.application.routes.url_helpers.purchase_pay_error_url(self)
    }
    Ds::Cart::Api.add_order(order_options)
  end

end
