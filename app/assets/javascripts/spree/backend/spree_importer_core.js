// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'

$(document).ready(function(){
  $('.import-logs a.plus').on('click', function(event){

    message = $(this).parent().parent().data('message')

    $('.import-logs .' + message +  ' a.plus').addClass('dn');

    $('.import-logs .' + message +  ' a.minus').removeClass('dn');
    $('.import-logs .' + message +  '.log-data').removeClass('dn');
    $('.import-logs .' + message +  '.log-backtrace').removeClass('dn');
  });

  $('.import-logs a.minus').on('click', function(event){

    message = $(this).parent().parent().data('message')

    $('.import-logs .' + message +  ' a.plus').removeClass('dn');

    $('.import-logs .' + message +  ' a.minus').addClass('dn');
    $('.import-logs .' + message +  '.log-data').addClass('dn');
    $('.import-logs .' + message +  '.log-backtrace').addClass('dn');
  });
});
