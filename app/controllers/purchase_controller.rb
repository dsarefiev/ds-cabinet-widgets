class PurchaseController < ApplicationController

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

  private

  def allow_iframe
    # response.headers['X-Frame-Options'] = 'ALLOW-FROM https://sredda.ru'
    response.headers.delete 'X-Frame-Options'
  end

end
