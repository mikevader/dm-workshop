import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log("qwerqwerqwer");
    }

    update(event) {
        console.log("woooohooooo");

        const url = document.querySelector('form.preview_form').getAttribute('action');
        const form = document.querySelector('form.preview_form');
        const data = new FormData(form);

        fetch((/.*\d$/.test(url)) ? url + "/preview/" : url + "/-1/preview/", {
            method: "PATCH",
            body: data
        })
            .then((respone) => {
                if (!respone.ok) {
                    throw new Error(`HTTP error: ${respone.status}`);
                }

                return respone.text();
            })
            .then((text) => {
                document.querySelector("div.preview_view").innerHTML = text;
            });
    }
}
