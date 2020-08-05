$(document).on('turbolinks:load', function() {

  // モーダル
  $('#open-modal').click(function() {
    $('#modal-area').fadeIn();
  });
  $('#modal-bg').click(function() {
    $('#modal-area').fadeOut();
  });
});
