import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  add(event) {
    console.log("add");
    const node = event.target || event.srcElement;

    const time = new Date().getTime();
    const regexp = new RegExp(node.getAttribute('data-id'), 'g');
    let newElement = document.createElement('div');
    node.parentNode.insertBefore(newElement, node);
    newElement.outerHTML = node.getAttribute('data-fields').replace(regexp, time);
    event.preventDefault();

  }

  remove(event) {
    console.log("remove");
  }

  // document.addEventListener("turbo:load", sortable);
    //
    // $(document).on('click', 'form .remove_fields', function(event) {
    //   $(this).prev('input[type=hidden]').val('1');
    //   $(this).closest('fieldset').hide();
    //   event.preventDefault();
    // });
    //


}
