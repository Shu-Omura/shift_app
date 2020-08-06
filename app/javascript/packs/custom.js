$(document).on('turbolinks:load', function() {

  // モーダル
  $('#collected-shift-open-modal').click(function() {
    $('#collected-shift-modal-area').fadeIn();
  });
  $('.modal-bg').click(function() {
    $('#collected-shift-modal-area').fadeOut();
    $('#attendance-modal-area').fadeOut();
  });

  $('#attendance-open-modal').click(function() {
    $('#attendance-modal-area').fadeIn();
  });
});
