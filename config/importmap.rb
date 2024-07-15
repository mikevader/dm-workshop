# Pin npm packages by running ./bin/importmap

# pin "jquery", to: "https://cdn.jsdelivr.net/npm/jquery@3.7.0/dist/jquery.js"
pin "application", preload: true
pin "print", preload: true
pin "admin", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom", under: "custom"
# pin "rails_admin", to: "https://cdn.jsdelivr.net/npm/rails_admin@3.1.2/src/rails_admin/base.min.js"
# pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
# pin "@rails/actioncable/src", to: "@rails--actioncable--src.js" # @7.1.3
# pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js"
# pin "flatpickr" # @4.6.13
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
# pin "bootstrap-icons", to: "https://cdn.skypack.dev/bootstrap-icons"
