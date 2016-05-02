"use strict";
(function(){
    $('.modal-trigger').leanModal(
      $('.abt-mdl').css("margin", ".5em 1em")
      );

    $('.likes-sort').on("click", function(){
        $('.index-order').hide();
        $('.top-comments').hide();
        $('.top-likes').show();
    });

    $('.comments-sort').on("click", function(){
        $('.index-order').hide();
        $('.top-likes').hide();
        $('.top-comments').show();
    });

})();
