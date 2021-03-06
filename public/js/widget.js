function createWidget(positionId, config) {
    var Util = {
        extendObject: function(a, b) {
            for(prop in b){
                a[prop] = b[prop];
            }
            return a;
        },
        proto: 'https:' == document.location.protocol ? 'https://' : 'http://'
    }

    var options = Util.extendObject({
        id: 0,
        domain: 'sredda.ru',
        path: '/',
        nocache: 0
    }, config);

    options.widget_url = [Util.proto, options.domain, options.path, "?", "id=", options.id, "&rnd=", options.nocache].join("");
    options.widget_url += "#" + encodeURIComponent(document.location.href);

    Widget = {
        created: false,
        widgetElement: null,
        show: function() {
            if (this.created)
                return;
            this.widgetElement = document.createElement('div');
            this.widgetElement.setAttribute('id', 'widget_container' + options.id);
            this.widgetElement.innerHTML = ' \
                <iframe id="widget_iframe' + options.id + '" src="' + options.widget_url + '" scrolling="no" width="100%" height="0" frameborder="0"></iframe>';

            position = document.getElementById(positionId);
            position.appendChild(this.widgetElement);

            this.widgetElement.style.display = 'block';
            this.created = true;
        }
    }

    XD.receiveMessage(function(message) {
        if (message.data > 0 && document.getElementById("widget_iframe" + options.id))
        {
            document.getElementById("widget_iframe" + options.id).height = message.data;
        }
    }, Util.proto + options.domain);

    Widget.show();
}
