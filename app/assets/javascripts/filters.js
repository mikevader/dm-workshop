var modal = function() {
    $('#saveFilterDialog').on('show.bs.modal', function (event) {
        var filterString = $('#search').val()

        var modal = $(this)
        modal.find('#filter_query').val(filterString)
    })
}

$(document).on("page:load ready", modal)


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



