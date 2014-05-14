class PurchasesController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index

  end

  def new

    # Очистка корзины если она не пустая
    if params[:with] == 'clear' && params[:client_siebel_id]
      Products.clear_cart(params[:client_siebel_id])
    end

    # TODO проверка валидности api_token

    @widget = Widgets.new(widget_params)
    if @widget.cart[:count] > 0
      @warning_message = 'В корзине клиента уже есть предложения: ' + @widget.cart[:items].first['Name']
      @params = params.merge({with:'clear'}).to_param
    else
      # Загружаем Предложения и цены
      @offerings = []
      Products.offerings.each do |offering_id|
        product = Products.new(offering_id)
        @offerings << {
          :product => product.offering,
          :prices => product.prices
        }
      end
      @api_token = api_token_params[:api_token]
    end
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
    widget = {
      widget_type: 'purchase',
      status: 'new',
      metadata: params[:offering].to_json
    }
    @widget = Widgets.create(widget.merge(widget_params))
    @title = "Предложение отправлено #{@widget.id}"

    # Создаем виджет в чате клиента через API
    topic = Ds::Cabinet::Api.create_topic(@widget, api_token_params[:api_token])
    if topic
      @widget.update_attributes(topic_id: topic['id'], status: 'chated')
    end
    render :widget
  rescue Ds::Cart::Error => e
    @error_message = e.message
    render :error
  end

  def show
    @widget = Widgets.find params[:widget_id]
    @title = "Виджет клиента"
    render :widget
  rescue ActiveRecord::RecordNotFound
    @error_message = 'Виджет не найден'
    render :error
  end

  private

  def widget_params
      params.permit(:client_id, :client_siebel_id, :owner_id)
  end

  def offering_params
      params.permit(offering: [])
  end

  def api_token_params
      params.permit(:api_token)
  end

end
