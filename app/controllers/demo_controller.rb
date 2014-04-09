class DemoController < ApplicationController

  def index

  end

  def concierge
    @user = {
      login: '+71111111120', # concierge
      siebel_id: '1-1ORN0Y',
      integration_id: 'UAS100452',
      api_token: 'd3cbe27b945f01e2d60188b94e9cb4fe4a1f69ade74094927ffd58e5b7045503'
    }
  end
end
