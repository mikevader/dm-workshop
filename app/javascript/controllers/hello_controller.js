import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

    // jquery versioon
    // var loaded = function () {
    //   $("#card_view").affix({
    //     offset: {top: 0}
    //   });
    //
    //   $('body').scrollspy({target: '#card_view', offset: 0});
    //
    //   $("[data-toggle='popover']")
    //       .popover("destroy")
    //       .popover({html: true});
    // }
    //
    // var updateCard = function (event) {
    //   var url = $('form.preview_form').attr('action');
    //   var params = $('form.preview_form').serialize();
    //   $.ajax({
    //     url: (/.*\d$/.test(url)) ? url + "/preview/" : url + "/-1/preview/",
    //     data: params,
    //     method: "PATCH",
    //     success: function (data) {
    //       $("div.preview_view").html(data)
    //     }
    //   })
    // };
    //
    // $(document).on('change', 'form.preview_form', updateCard);
    // document.addEventListener("turbo:load", loaded);
    //
    // var modal = function (event) {
    //   var modal = $(this)
    //   var cardPath = modal.data('card').replace(' ', '_')
    //   var modal_size = modal.data('size')
    //   var target = '#' + modal.attr('id')
    //   var nextid = modal.data('nextid')
    //   var previd = modal.data('previd')
    //
    //   if ($(target).find('.modal-body').length == 0) {
    //     $.ajax({
    //       url: cardPath,
    //       data: {index: target.substring(1), nextid: nextid, previd: previd, modal_size: modal_size},
    //       method: "GET",
    //       success: function (data) {
    //         $(target).find('.modal-content').append(data)
    //       }
    //     })
    //   }
    // }
    //
    // var loader = function () {
    //   $('div.modal.card-dialog').on('show.bs.modal', modal)
    //
    // }
    //
    // document.addEventListener("turbo:load", loader)
    //
    // var sortable = function () {
    //   var cells, desired_width, table_width;
    //   if ($('.sortable').length > 0) {
    //     table_width = $('.sortable').width();
    //     //cells = $('.table').find('tr')[0].cells.length;
    //     desired_width = table_width / cells + 'px';
    //     $('.table td').css('width', desired_width);
    //     return $('.sortable').sortable({
    //       axis: 'y',
    //       items: '.item',
    //       cursor: 'move',
    //       sort: function (e, ui) {
    //         return ui.item.addClass('active-item-shadow');
    //       },
    //       stop: function (e, ui) {
    //         ui.item.removeClass('active-item-shadow');
    //         return ui.item.children('.item').effect('highlight', {}, 1000);
    //       },
    //       update: function (e, ui) {
    //         $(ui.item).parent().children('.item').each(function(index, element) {
    //           var position_field = $('input[id*=position]', element)
    //           position_field.val(index +1);
    //         });
    //
    //         updateCard();
    //       }
    //     });
    //   }
    // }
    //
    // document.addEventListener("turbo:load", sortable);
    //
    // $(document).on('click', 'form .remove_fields', function(event) {
    //   $(this).prev('input[type=hidden]').val('1');
    //   $(this).closest('fieldset').hide();
    //   event.preventDefault();
    // });
    //
    // $(document).on('click', 'form .add_fields', function(event) {
    //   var time = new Date().getTime();
    //   var regexp = new RegExp($(this).data('id'), 'g');
    //   $(this).before($(this).data('fields').replace(regexp, time));
    //   event.preventDefault();
    // });

    // non jquery:
    var loaded = function () {
      document.querySelector("#card_view").affix({
        offset: {top: 0}
      });

      document.querySelector('body').scrollspy({target: '#card_view', offset: 0});

      document.querySelector("[data-toggle='popover']")
          .popover("destroy")
          .popover({html: true});
    }

    var updateCard = function (event) {
      var url = document.querySelector('form.preview_form').attr('action');
      var params = document.querySelector('form.preview_form').serialize();
      document.querySelector.ajax({
        url: (/.*\ddocument.querySelector/.test(url)) ? url + "/preview/" : url + "/-1/preview/",
        data: params,
        method: "PATCH",
        success: function (data) {
          document.querySelector("div.preview_view").html(data)
        }
      })
    };

    document.querySelector(document).on('change', 'form.preview_form', updateCard);
    document.addEventListener("turbo:load", loaded);

    var modal = function (event) {
      var modal = document.querySelector(this)
      var cardPath = modal.data('card').replace(' ', '_')
      var modal_size = modal.data('size')
      var target = '#' + modal.attr('id')
      var nextid = modal.data('nextid')
      var previd = modal.data('previd')

      if (document.querySelector(target).find('.modal-body').length == 0) {
        document.querySelector.ajax({
          url: cardPath,
          data: {index: target.substring(1), nextid: nextid, previd: previd, modal_size: modal_size},
          method: "GET",
          success: function (data) {
            document.querySelector(target).find('.modal-content').append(data)
          }
        })
      }
    }

    var loader = function () {
      document.querySelector('div.modal.card-dialog').on('show.bs.modal', modal)

    }

    document.addEventListener("turbo:load", loader)

    var sortable = function () {
      var cells, desired_width, table_width;
      if (document.querySelector('.sortable').length > 0) {
        table_width = document.querySelector('.sortable').width();
        //cells = document.querySelector('.table').find('tr')[0].cells.length;
        desired_width = table_width / cells + 'px';
        document.querySelector('.table td').css('width', desired_width);
        return document.querySelector('.sortable').sortable({
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
            document.querySelector(ui.item).parent().children('.item').each(function(index, element) {
              var position_field = document.querySelector('input[id*=position]', element)
              position_field.val(index +1);
            });

            updateCard();
          }
        });
      }
    }

    document.addEventListener("turbo:load", sortable);

    document.querySelector(document).on('click', 'form .remove_fields', function(event) {
      document.querySelector(this).prev('input[type=hidden]').val('1');
      document.querySelector(this).closest('fieldset').hide();
      event.preventDefault();
    });

    document.querySelector(document).on('click', 'form .add_fields', function(event) {
      var time = new Date().getTime();
      var regexp = new RegExp(document.querySelector(this).data('id'), 'g');
      document.querySelector(this).before(document.querySelector(this).data('fields').replace(regexp, time));
      event.preventDefault();
    });

  }
}
