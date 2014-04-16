class PurchasesController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index

  end

  def new
    # TODO проверка валидности api_token
    @widget = Widgets.new(widget_params)
    @api_token = params[:api_token]
    render :concierge
  end

  def create
    @widget = Widgets.create(widget_params)
    @message = "Предложение отправлено"
    render :widget
  end

  def show
    @widget = Widgets.find params[:widget_id]
    @message = "Виджет клиента"
    render :widget
  end

  private

  def widget_params
      params.permit(:client_id, :owner_id)
  end

end
