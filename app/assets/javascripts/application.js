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


var loaded = function() {
    $("#card_view").affix({
        offset: { top: 0 }
    });

    $('body').scrollspy({ target: '#card_view', offset: 0 });
}

var updateCard = function(event) {
    var url = $('form.preview_form').attr('action');
    var params = $('form.preview_form').serialize();
    $.ajax({
        url: (/.*\d$/.test(url)) ? url + "/preview/" : url + "/-1/preview/",
        data: params,
        method: "PATCH",
        success: function (data) {
            $("div.preview_view").html(data)
        }
    })
};

$(document).on('change', 'form.preview_form', updateCard);
$(document).on("turbolinks:load", loaded);

var modal = function(event) {
    var modal = $(this)
    var cardPath = modal.data('card').replace(' ', '_')
    var modal_size = modal.data('size')
    var target = '#' + modal.attr('id')
    var nextid = modal.data('nextid')
    var previd = modal.data('previd')

    if ($(target).find('.modal-body').length == 0) {
        $.ajax({
            url: cardPath,
            data: {index: target.substring(1), nextid: nextid, previd: previd, modal_size: modal_size},
            method: "GET",
            success: function(data) {
                $(target).find('.modal-content').append(data)
            }
        })
    }
}

var loader = function() {
    $('div.modal.card-dialog').on('show.bs.modal', modal)

}

$(document).on("turbolinks:load", loader)

$(function () {
    $('[data-toggle="popover"]').popover({html: true})
})