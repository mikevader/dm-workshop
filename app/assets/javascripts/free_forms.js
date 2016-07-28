//= require bootstrap-colorselector

var loadColor = function() {
    $('#colorselector').colorselector({
        callback: function(value, color, title) {
            $('#free_form_color').val(color);
        }
    });

    ui_change_default_color();
    $("#free_form_color").change(ui_change_default_color);
};


function ui_update_card_color_selector(color, input, selector) {
    if ($(selector + " option[value='" + color + "']").length > 0) {
        // Update the color selector to the entered value
        $(selector).colorselector("setValue", color);
    } else {
        // Unknown color - select a neutral color and reset the text value
        $(selector).colorselector("setValue", "");
        input.val(color);
    }
}

function ui_change_default_color() {
    var input = $('#free_form_color');
    var color = input.val();

    ui_update_card_color_selector(color, input, "#colorselector");
}


$(document).on("turbolinks:load", loadColor);
