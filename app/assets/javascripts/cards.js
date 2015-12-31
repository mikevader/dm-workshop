/**
 * Created by michael on 31/12/15.
 */
var updateCard = function(event) {
    var id = $('form.edit_card').attr('action').split('/').pop();
    var params = $('form.edit_card').serialize();
    $.ajax({
        url: "/cards/change_card/" + id,
        data: params,
        type: "GET",
        success: function (data) {
            $("div#card_view").html(data)
        }
    })
};

$(document).on('change', 'form.edit_card', updateCard);
