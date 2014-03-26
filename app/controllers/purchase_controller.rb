class PurchaseController < ApplicationController
  before_action :authorize
  after_action :allow_iframe

  def index
    token = request.cookies['auth_token']
    @message = "виджет клиента: token=" + token
    render :widget
  end

  def concierge
    @message = "виджет консьержа"
    render :widget
  end

end
