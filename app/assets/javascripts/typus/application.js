//= require typus/jquery-1.8.3-min
//= require jquery_ujs
//= require js/bootstrap.min.js
//= require typus/jquery.application
//= require typus/custom

$(".ajax-modal").live('click', function() {
  var url = $(this).attr('url');
  var modal_id = $(this).attr('data-controls-modal');
  $("#" + modal_id + " .modal-body").load(url);
});
