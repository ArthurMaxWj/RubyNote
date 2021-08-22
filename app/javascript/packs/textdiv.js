preview = false;
function toggleAjaxThing() {
    if (preview) {
        preview = false;
        $('.textdiv .codearea').show();
        $('.textdiv .previewarea').hide();
    }
    else {
        preview = true;
        $('.textdiv .codearea').hide();
        inp = $('.textdiv .codearea').val();

        $.get( "/preprocess?code=ok", { 'code': inp}, function(data) {
           $(".textdiv .previewarea").html('<pre>' + data['converted'] + '</pre>');
        }, 'json');

        $('.textdiv .previewarea').show();
    }
}

$(document).ready(function(){
    $('.textdiv .previewarea').hide();

    $('.textdiv nav .eye').click(function() {
        $('.textdiv nav .eye').toggleClass('activated');
        toggleAjaxThing();
    });
});