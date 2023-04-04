// Entry point for the build script in your package.json
import "./controllers"
import "@hotwired/turbo-rails"


require("@rails/activestorage").start()
require.context("./application/images", true)

import "@fortawesome/fontawesome-free/js/all"
import "./application/stylesheets/application"
import "animate.css"
