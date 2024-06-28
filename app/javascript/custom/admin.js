const selectAll = function () {
    document.querySelector('#selectAll').addEventListener('change', function () {
        if (this.checked) {
            document.querySelectorAll('input[type=checkbox]').forEach(function (checkbox) {
                checkbox.checked = true;
            });
        } else {
            document.querySelectorAll('input[type=checkbox]').forEach(function (checkbox) {
                checkbox.checked = false;
            });
        }
    });
};

document.addEventListener("DOMContentLoaded", selectAll);
