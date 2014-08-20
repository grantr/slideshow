function updateSlides() {
    var div = $('#fotorama');
    lastUpdate = div.attr('data-lastupdate');

    if (lastUpdate == undefined) {
      var url = '/ajax/get_photos/' + eventID;
    } else {
      var url = '/ajax/get_photos/' + eventID + "/" + lastUpdate
    }

    $.get(url, function(data){
    // $.ajax({
    //     url: url,
    //     type: '',
    //     crossDomain: false,
    //     dataType: 'json'

        // headers: { 'X-Requested-With': 'XMLHttpRequest' }
    // }).done(function(data){
        var resp = $.parseJSON(data);
        console.log(resp.objects);
        for (index = 0; index < resp.objects.length; index++) {
          console.log(resp.objects[index].resource_uri);
            var photo_id_parts = resp.objects[index].resource_uri.split('/')
            var photo_id = photo_id_parts[photo_id_parts.length - 2];
            photo = {
              img: 'https://snapable.com/p/get/' + photo_id + '/orig'
            }
            $fotorama.push(photo);
            // caption = resp.objects[index].caption;
        }
        //TODO remove oldest
        var slideCount = $('#fotorama img').length;
    });

    div.attr('data-lastupdate', new Date().getTime() / 1000)
}

$(document).ready(function(){
    // start the slides
    $fotoramaDiv = $("#fotorama").fotorama();

    $fotorama = $fotoramaDiv.data('fotorama');

    // setup the code to do ajax calls and update the dom
    setInterval(updateSlides, 30000); // 30 sec

    $('#fotorama').on('fotorama:load', function (e, fotorama, extra) {
      console.log(extra.src + ' is loaded');
    });
    updateSlides();

});
