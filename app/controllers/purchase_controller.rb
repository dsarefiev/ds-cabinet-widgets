class PurchaseController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index
    @message = "Виджет клиента"
    render :widget
  end

  def concierge
    @message = "Виджет консьержа"
    @api_token = params[:api_token]
  end

end
