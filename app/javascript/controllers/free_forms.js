
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        // var loadColor = function() {
        //     $('#colorselector').colorselector({
        //         callback: function(value, color, title) {
        //             $('#free_form_color').val(color);
        //         }
        //     });
        //
        //     ui_change_default_color();
        //     $("#free_form_color").change(ui_change_default_color);
        // };
        //
        //
        // function ui_update_card_color_selector(color, input, selector) {
        //     if ($(selector + " option[value='" + color + "']").length > 0) {
        //         // Update the color selector to the entered value
        //         $(selector).colorselector("setValue", color);
        //     } else {
        //         // Unknown color - select a neutral color and reset the text value
        //         $(selector).colorselector("setValue", "");
        //         input.val(color);
        //     }
        // }
        //
        // function ui_change_default_color() {
        //     var input = $('#free_form_color');
        //     var color = input.val();
        //
        //     ui_update_card_color_selector(color, input, "#colorselector");
        // }

        var loadColor = function() {
            document.querySelector('#colorselector').colorselector({
                callback: function(value, color, title) {
                    document.querySelector('#free_form_color').val(color);
                }
            });

            ui_change_default_color();
            document.querySelector("#free_form_color").change(ui_change_default_color);
        };


        function ui_update_card_color_selector(color, input, selector) {
            if (document.querySelector(selector + " option[value='" + color + "']").length > 0) {
                // Update the color selector to the entered value
                document.querySelector(selector).colorselector("setValue", color);
            } else {
                // Unknown color - select a neutral color and reset the text value
                document.querySelector(selector).colorselector("setValue", "");
                input.val(color);
            }
        }

        function ui_change_default_color() {
            var input = document.querySelector('#free_form_color');
            var color = input.val();

            ui_update_card_color_selector(color, input, "#colorselector");
        }

        document.addEventListener("turbo:load", loadColor);
    }
}
