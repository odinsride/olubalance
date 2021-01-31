// Core libraries
//require.context("../application/images", true)

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import "@fortawesome/fontawesome-free/js/all"
import "../application/stylesheets/application"
const images = require.context("../application/images", true)
import "controllers"
import "animate.css"
