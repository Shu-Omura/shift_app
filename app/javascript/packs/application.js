require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")
require("bootstrap")

import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';

document.addEventListener('DOMContentLoaded', function() {
  var calendarEl = document.getElementById('calendar');

  let calendar = new Calendar(calendarEl, {
    plugins: [ dayGridPlugin ],
    initialView: 'dayGridMonth'
  });

  calendar.render();
});

$(function() {
  $('#open-modal').click(function() {
    $('#modal-area').fadeIn();
  });
  $('#modal-bg').click(function() {
    $('#modal-area').fadeOut();
  });
});
