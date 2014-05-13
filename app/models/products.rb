class Products

  attr_accessor :offering_id

  def self.offerings
    Rails.configuration.pim_product_offerings
  end

  def initialize(offering_id)
    @offering_id = offering_id
  end

  def offering
    Ds::Pim::Api.get_product_offering(offering_id)
  end

  def prices
    Ds::Pim::Api.get_product_offering_prices(offering_id)
  end

  def self.add_to_cart(options = nil)

    return false if !options

    offering = {
      OfferingId: options[:offering_id],
      OfferingPriceId: options[:offering_price_id],
      Characteristics: [],
      ClientKey: options[:siebel_id],
    }

    Ds::Cart::Api.add_to_cart(offering, Rails.configuration.pim_product_url)

  end

end
