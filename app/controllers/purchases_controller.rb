class PurchasesController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index

  end

  def new

    # Очистка корзины если она не пустая
    # if params[:with] == 'clear' && params[:client_siebel_id]
      # Products.clear_cart(params[:client_siebel_id])
    # end

    # TODO проверка валидности api_token

    @widget = Widgets.new(widget_params)
    # TODO проверка на существование заказа
    # if @widget.cart[:count] > 0
    #   @warning_message = 'В корзине клиента уже есть предложения: ' + @widget.cart[:items].first['Name']
    #   @params = params.merge({with:'clear'}).to_param
    # else

      # Загружаем Предложения и цены
      @products = []
      Products.offerings.each do |offering_id|
        product = Products.new(offering_id)
        @products << {
          offering: product.offering,
          prices: product.prices
        }
      end
      @api_token = api_token_params[:api_token]

    render :concierge
  end

  def create

    # Кладем товар в корзину
    # cart_option = {
    #   :offering_id => params[:offering].keys.first,
    #   :offering_price_id => params[:offering].values.first,
    #   :client_siebel_id => params[:client_siebel_id]
    # }

    # Создаем Order
    order_response = Products.add_order(order_params)
    # Сохраняем виджет в базу
    widget = {
      widget_type: 'purchase',
      status: 'new',
      order_id: order_response['OrderId'],
      target_url: order_response['TargetUrl'],
      offerings: params[:offerings].to_json
    }
    @widget = Widgets.create(widget.merge(widget_params))
    @title = "Предложение отправлено"

    # Создаем виджет в чате клиента через API
    topic = Ds::Cabinet::Api.create_topic(@widget, api_token_params[:api_token])
    if topic
      @widget.update_attributes(topic_id: topic['id'], status: 'chated')
    end
    redirect_to :action => 'show'
  rescue Ds::Cart::Error => e
    @error_message = e.message
    render :error
  end

  def show
    if topic_params
      @widget = Widgets.last_active.find_by topic_params
    elsif current_user
      @widget = Widgets.last_active.find_by_client_integration_id current_user.user_id
    else
      @widget = Widgets.last_active.take
    end
    if @widget
      @title = "Виджет клиента"
      @current_user_phone = @current_user.login[-10, 10]
      render :widget
    else
      raise ActiveRecord::RecordNotFound
    end
  rescue ActiveRecord::RecordNotFound
    @error_message = 'Виджет не найден'
    render :error
  end

  private

  def widget_params
    params[:client_integration_id] = params[:client_siebel_id] if params[:client_siebel_id]
    params.permit(:client_id, :client_integration_id, :owner_id)
  end

  def order_params
    params.permit(:client_integration_id, offerings: params[:offerings].try(:keys))
  end

  def topic_params
    params.permit(:topic_id)
  end

  def api_token_params
    params.permit(:api_token)
  end

end
