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
//= require jquery-ui/widgets/sortable
//= require jquery-ui/effects/effect-highlight
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require bootstrap-sprockets
//= require turbolinks
//= require analytics
//= require item_properties
//= require_self


var loaded = function () {
    $("#card_view").affix({
        offset: {top: 0}
    });

    $('body').scrollspy({target: '#card_view', offset: 0});

    $("[data-toggle='popover']")
        .popover("destroy")
        .popover({html: true});
}

var updateCard = function (event) {
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

var modal = function (event) {
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
            success: function (data) {
                $(target).find('.modal-content').append(data)
            }
        })
    }
}

var loader = function () {
    $('div.modal.card-dialog').on('show.bs.modal', modal)

}

$(document).on("turbolinks:load", loader)

var sortable = function () {
    var cells, desired_width, table_width;
    if ($('.sortable').length > 0) {
        table_width = $('.sortable').width();
        //cells = $('.table').find('tr')[0].cells.length;
        desired_width = table_width / cells + 'px';
        $('.table td').css('width', desired_width);
        return $('.sortable').sortable({
            axis: 'y',
            items: '.item',
            cursor: 'move',
            sort: function (e, ui) {
                return ui.item.addClass('active-item-shadow');
            },
            stop: function (e, ui) {
                ui.item.removeClass('active-item-shadow');
                return ui.item.children('.item').effect('highlight', {}, 1000);
            },
            update: function (e, ui) {
                $(ui.item).parent().children('.item').each(function(index, element) {
                    var position_field = $('input[id*=position]', element)
                    position_field.val(index +1);
                });

                updateCard();
            }
        });
    }
}

$(document).on("turbolinks:load", sortable);
