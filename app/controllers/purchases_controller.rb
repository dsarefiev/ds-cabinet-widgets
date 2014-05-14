class PurchasesController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index

  end

  def new
    # TODO проверка валидности api_token

    # Загружаем Предложения и цены
    @offerings = []
    Products.offerings.each do |offering_id|
      product = Products.new(offering_id)
      @offerings << {
        :product => product.offering,
        :prices => product.prices
      }
    end
    @widget = Widgets.new(widget_params)
    @api_token = api_token_params[:api_token]
    render :concierge
  end

  def create
    # Кладем товар в корзину

    cart_option = {
      :offering_id => params[:offering].keys.first,
      :offering_price_id => params[:offering].values.first,
      :client_siebel_id => params[:client_siebel_id]
    }
    @cart_response = Products.add_to_cart(cart_option)

    # Сохраняем виджет в базу
    @widget = Widgets.create(widget_params.merge({metadata: offering_params.to_json}))
    @title = "Предложение отправлено #{@widget.id}"

    # Создаем виджет в чате клиента через API
    puts Ds::Cabinet::Api.create_topic(@widget, api_token_params[:api_token])

    render :widget

    rescue Ds::Cart::Error => e
      @error_message = e.message
      render :error
  end

  def show
    @widget = Widgets.find params[:widget_id]
    @title = "Виджет клиента"
    render :widget
  end

  private

  def widget_params
      params.permit(:client_id, :client_siebel_id, :owner_id)
  end

  def offering_params
      params.permit(:offering)
  end

  def api_token_params
      params.permit(:api_token)
  end

end
