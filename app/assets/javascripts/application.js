// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require item_properties
//= require_self

$(document).ready(function() {
    $("textarea#card_contents").change(function() {
        var id = $('form.edit_card').attr('action').split('/').pop();
        var name = $('form.edit_card > input#card_name').val();
        var icon = $('form.edit_card > input#card_icon').val();
        var color = $('form.edit_card > input#card_color').val();
        var contents = escape($('form.edit_card > textarea#card_contents').val());
        var params = 'card[name]=' + name + ';card[icon]=' + icon + ';card[color]=' + color + ';card[contents]=' + contents;
        $.ajax({
            url : "/cards/change_card/" + id,
            data : params,
            type: "GET",
            success : function(data) {
                $("div#card_view").html(data)
            }
        })
    })
});
