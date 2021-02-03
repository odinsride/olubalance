import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "@fortawesome/fontawesome-free/js/all"
import "stylesheets/application"
const images = require.context("images", true)
import "controllers"