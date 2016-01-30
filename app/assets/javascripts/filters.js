var saveDialogLoader = function() {
    $('#saveFilterDialog').on('show.bs.modal', function (event) {
        var filterString = $('#search').val()

        var modal = $(this)
        modal.find('#filter_query').val(filterString)
        var filterName = $('.search-header > #filter_title').text()

        modal.find('#filter_name').val(filterName)
    })
}

$(document).on("page:load ready", saveDialogLoader)


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



