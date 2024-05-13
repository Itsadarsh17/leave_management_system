// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import("jquery")

import $ from 'jquery';
global.$ = jQuery;

require("packs/bootstrap.min")
require("packs/material.min")
require("packs/perfect-scrollbar.jquery.min")
require("packs/arrive.min")
require("packs/jquery.validate.min")
require("packs/moment.min")
require("packs/jquery.bootstrap-wizard")
require("packs/bootstrap-notify")
require("packs/bootstrap-datetimepicker")
require("packs/jquery-jvectormap")
require("packs/nouislider.min")
require("packs/jquery.select-bootstrap")
require("packs/sweetalert2")
// require("packs/jasny-bootstrap.min")
require("packs/fullcalendar.min")
// require("packs/jquery.tagsinput")
require("packs/material-dashboard")
require("packs/demo")
