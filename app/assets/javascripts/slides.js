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

      var prior_size = $fotorama.size;
      var photos = data.photos;
      for (index = 0; index < photos.length; index++) {
        photo = photos[index];
        photo_hash = {
          id: photo.id,
          img: photo.url,
          caption: photo.caption,
          created_at: photo.created_at
        }
        if ($photo_ids[photo.id] == true) {
          for (j = 0; j < $fotorama.size; j++) {
            if ($fotorama.data[j].id == photo.id) {
              if (photo.deleted_at == null) {
                console.log("Updating photo " + photo.id);
                $fotorama.splice(j, 1, photo_hash);
              } else {
                console.log("Deleting photo " + photo.id);
                $fotorama.splice(j, 1);
                $photo_ids[photo.id] = false;
              }
            }
          }
        } else {
          if (photo.deleted_at == null) {
            console.log("Adding photo " + photo.id);
            $fotorama.push(photo_hash);
            $photo_ids[photo.id] = true;
          }
        }
      }
      var max_size = 85;
      if ($fotorama.size > max_size) {
        console.log("Culling down from " + $fotorama.size);
        grace_time = (new Date().getTime() / 1000) - (30*60);
        $fotorama.sort(function(a,b) {
          if (a.created_at > b.created_at) return 1;
          if (a.created_at < b.created_at) return -1;
          return 0;
        });

        while ($fotorama.size > max_size) {
          photo_hash = $fotorama.data[0];
          if (photo_hash.created_at >= grace_time) break;
          age = ((new Date().getTime() / 1000) - photo_hash.created_at) / 60;
          console.log("Culling " + photo_hash.id + " (" + age + ' minutes old)');
          $photo_ids[photo.id] = false;
          $fotorama.shift();
        }
        console.log("Culled to size " + $fotorama.size);
      }
      if ($fotorama.size != prior_size) {
        console.log("Shuffling");
        $fotorama.shuffle();
      }
      div.attr('data-lastupdate', new Date().getTime() / 1000);
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
