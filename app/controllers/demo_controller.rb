class DemoController < ApplicationController
  before_action :get_demo_data

  def index

  end

  def get_demo_data
    @user = {
      id: 1,
      login: '+71111111120', # concierge
      siebel_id: '1-1ORN0Y',
      integration_id: 'UAS100452',
      api_token: 'd3cbe27b945f01e2d60188b94e9cb4fe4a1f69ade74094927ffd58e5b7045503'
    }
    @client = {
      id: 2,
      integration_id: 'UAS100397'
    }
    widget = Widgets.last_active.find_by_client_integration_id @client[:integration_id]
    @topic = {
      id: widget ? widget.topic_id : 1
    }
    @domain = Rails.configuration.widget_domain
  end

  def concierge
  end

  def show_modal
    render layout: false
  end

  def show_cart
    if current_user
      @cart_summary = Ds::Cart::Api.get_cart_summary(
        # current_user.user_id
        'UAS100397'
      )
      @cart_items1 = Ds::Cart::Api.get_cart_items(
        # current_user.user_id
        'UAS100397'
      )
    end
    render :index
  end

  def delete_cart
    if current_user
      Ds::Store::Api.instance.cart_delete(4836)
    end
    render :index
  end

  def add_to_cart
    if current_user

    subject_parameters = {
      OfferingId: 5336743,
      OfferingPriceId: "5336753",
      Characteristics: [],
      # ClientKey: "IF7yM",
      ClientKey: current_user.user_id,
      # ClientSessionKey: cookies['dsclsk']
    }

    subject_url = 'http://dsstore.dasreda.ru/'

    @store_api_respond = Ds::Store::Api.instance.add_to_cart(subject_parameters, subject_url)

    end
    render :index
  end

end
