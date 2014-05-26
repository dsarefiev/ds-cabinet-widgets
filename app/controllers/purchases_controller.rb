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

    # Сохраняем виджет в базу
    widget = {
      widget_type: 'purchase',
      owner_integration_id: @current_user.user_id,
      status: 'new',
      offerings: params[:offerings].to_json
    }
    @widget = Widgets.create(widget.merge(widget_params))

    # Создаем Order
    order_response = @widget.add_order(order_params)
    if order_response
      @widget.update_attributes(
        order_id: order_response['OrderId'],
        target_url: order_response['TargetUrl'])
    end
    # Создаем виджет в чате клиента через API
    topic = Ds::Cabinet::Api.create_topic(@widget, api_token_params[:api_token])
    if topic
      @widget.update_attributes(
        topic_id: topic['id'],
        status: 'chated')
    end
    redirect_to :action => 'show', :id => @widget.id
  rescue Ds::Cart::Error => e
    @error_message = e.message
    render :error
  end

  def show
    if topic_params[:topic_id]
      @widget = Widgets.last_active.find_by topic_params
    elsif id_params[:id]
      @widget = Widgets.find id_params[:id]
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

  # pay_success pay_error
  def update_status
    @widget = Widgets.find id_params[:id]
    @widget.update_status_from_order
    redirect_to :action => 'show', :id => @widget.id
  end


  private

  def id_params
    params.permit(:id)
  end

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
