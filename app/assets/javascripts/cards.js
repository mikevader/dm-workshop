
var modal = function() {
    $('#saveFilterDialog').on('show.bs.modal', function (event) {
        var filterString = $('#search').val()

        var modal = $(this)
        modal.find('#filter_query').val(filterString)
    })
}

$(document).on("page:load ready", modal)

