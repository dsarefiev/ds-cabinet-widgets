Client Cabinet Widgets
======================

## Widget to Chat Integration: Step 2

### 1. Вызов клиентского виджета

Файл:
	/app/views/topics/_topic_purchase.html.erb


Код:

		<div id="widget_<%= topic.id %>"></div>
		<script type="text/javascript">
		  var widgetOptions = {
		    id: <%= topic.id %>,
		    domain: 'delo-widgets-dev.sredda.ru:8082',
		    path: '/purchases/show',
		    params: {
		      topic_id: <%= topic.id %>
		    }
		  };
		  createWidget('widget_<%= topic.id %>', widgetOptions);
		</script>
		
#### Важные изменения:
> id: нужен только для уникальности елементов на странице

> path: /purchase -> /purchases/show

> добавился хеш params: { topic_id: ... } для поиска нужного виджет
	 
	 
### 2. Вызов виджета консьержа

#### Кнопка вызова модального окна с виджетом

Файл:
	/app/views/concierge/users/index.html.slim

Код:

		= link_to 'Создать виджет', create_widget_concierge_user_path(user), class: 'show-modal-window btn btn-sm', data: { target: '#modal-window', toggle: 'modal' }

#### Создать PATH в Routes
GET /concierge/users/:id/create_widget

#### Создать метод create_widget(user) в Concierge::UsersController
отрендерить шаблон c create_widget.html.erb c layout: false


### Шаблон модального окна

Файл:
	/app/views/concierge/users/create_widget.html.erb

Код:

		<div class="modal-dialog">
		  <div class="modal-content">
		    <div class="modal-header">
		      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		      <h4 class="modal-title">Создать топик-предложение</h4>
		    </div>
		    <div class="modal-body">
		
		<div id="widget_<%= @user.id %>"></div>
		<script type="text/javascript">
		  var widgetOptions = {
		    id: <%= @user.id %>,
		    domain: 'delo-widgets-dev.sredda.ru:8082',
		    path: '/purchases/new',
		    params: {
		      owner_id: <%= @current_user.id %>,
		      api_token: '<%= @current_user.api_token %>',
		      client_id: <%= @user.id %>,
		      client_siebel_id: '<%= @user.user_id %>'
		    }
		  };
		  createWidget('widget_<%= @user.id %>', widgetOptions);
		</script>
		
		    </div>
		  </div>
		</div>

