function widgetMessage(config) {
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
        domain: 'sredda.ru',
    }, config);


    XD.receiveMessage(function(message) {
        console.log(message.data)
    }, Util.proto + options.domain);

}
