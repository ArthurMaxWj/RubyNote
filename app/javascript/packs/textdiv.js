function htmlize(str) {
    return str.replaceAll('&amp;', '&').replaceAll('&lt;', '<').replaceAll('&gt;', '>')
}

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
            // OPTIMIZE 'htmlize' shouldn't be need plus it affects the Ruby code as well
           $(".textdiv .previewarea").html(htmlize(data['converted']));
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