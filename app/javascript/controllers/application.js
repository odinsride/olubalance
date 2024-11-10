import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Tailwind Stimulus Components
import { Dropdown } from 'tailwindcss-stimulus-components';
application.register('dropdown', Dropdown);

import { Toggle } from 'tailwindcss-stimulus-components';
application.register('toggle', Toggle);

import { Modal } from 'tailwindcss-stimulus-components';
application.register('modal', Modal);


// Custom Stimulus Controllers
import AcctformController from "./acctform_controller"
application.register("acctform", AcctformController)

export { application }
