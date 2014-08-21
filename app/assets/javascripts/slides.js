function updateSlides() {
    var div = $('#fotorama');
    lastUpdate = div.attr('data-lastupdate');

    if (lastUpdate == undefined) {
      var url = '/photos';
    } else {
      var url = '/photos?timestamp=' + lastUpdate;
    }

    $.get(url, function(data){
        console.log("data");
        console.log(data);
        photos = data.photos;
        for (index = 0; index < photos.length; index++) {
            photo = {
              img: photos[index].url,
              caption: photos[index].caption
            }
            $fotorama.push(photo);
            //TODO remove oldest
        }
        var slideCount = $('#fotorama img').length;
        div.attr('data-lastupdate', new Date().getTime() / 1000)
    });
}

$(document).ready(function(){
    // start the slides
    $fotoramaDiv = $("#fotorama").fotorama();

    $fotorama = $fotoramaDiv.data('fotorama');

    // setup the code to do ajax calls and update the dom
    setInterval(updateSlides, 30000); // 30 sec

    updateSlides();
});
