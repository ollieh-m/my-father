/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb
import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
Rails.start();
Turbolinks.start();
import 'core-js/stable'
import 'regenerator-runtime/runtime'

require("jquery-ui/ui/widgets/sortable");

import 'jquery_plugins';
import 'admin_sections_page';
import 'admin_edit_section_page';
import 'animated_nav';
import 'modals';
import 'flash';
import 'menu_toggle';