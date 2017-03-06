jsclick = function (event, data) {
    var addSpell = $('a.add_fields');
    var time = new Date().getTime();
    var regexp = new RegExp($(addSpell).data('id'), 'g');
    $(addSpell).before($(addSpell).data('fields').replace(regexp, time));
    $('.asdf:last').focus();

    updateAutocreateHandlers();
};

$(document).on('railsAutocomplete.select', '.asdf:last', jsclick);

$(document).on('click', 'a.add_fields', function (event, data) {
    updateAutocreateHandlers();
});
