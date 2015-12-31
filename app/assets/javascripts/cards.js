/**
 * Created by michael on 31/12/15.
 */
var updateCard = function(event) {
    var url = $('form.preview_form').attr('action');
    var params = $('form.preview_form').serialize();
    $.ajax({
        url: url + "/preview/",
        data: params,
        type: "GET",
        success: function (data) {
            $("div.preview_view").html(data)
        }
    })
};

$(document).on('change', 'form.preview_form', updateCard);
