// Core libraries
require("turbolinks").start()
require("@rails/ujs").start()
require("@rails/actioncable")
require("@rails/activestorage").start()
require("channels")
require.context("../application/images", true)

import "@fortawesome/fontawesome-free/js/all"
import "../application/stylesheets/application"
import "controllers"
