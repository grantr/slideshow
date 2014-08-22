function updateSlides() {
    var div = $('#fotorama');
    lastUpdate = div.attr('data-lastupdate');

    if (lastUpdate == undefined) {
      var url = '/photos';
    } else {
      var url = '/photos?timestamp=' + lastUpdate;
    }

    $.get(url, function(data){
      console.log(data);

      photos = data.photos;
      for (index = 0; index < photos.length; index++) {
        photo = photos[index];
        photo_hash = {
          id: photo.id,
          img: photo.url,
          caption: photo.caption
        }
        if ($photo_ids[photo.id] == true) {
          for (j = 0; j < $fotorama.size; j++) {
            if ($fotorama.data[j].id == photo.id) {
              if (photo.deleted_at == null) {
                $fotorama.splice(j, 1, photo_hash);
              } else {
                $fotorama.splice(j, 1);
                $photo_ids[photo.id] = false
              }
            }
          }
        } else {
          if (photo.deleted_at == null) {
            $fotorama.push(photo_hash);
            $photo_ids[photo.id] = true
          }
        }
        if ($fotorama.size > 50) {
          $fotorama.shift();
        }
      }
      div.attr('data-lastupdate', new Date().getTime() / 1000)
    });
}

$(document).ready(function(){
    // start the slides
    $fotoramaDiv = $("#fotorama").fotorama();

    $fotorama = $fotoramaDiv.data('fotorama');

    $photo_ids = {};

    // setup the code to do ajax calls and update the dom
    setInterval(updateSlides, 30000); // 30 sec

    updateSlides();
});
