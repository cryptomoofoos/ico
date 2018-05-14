// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require site/popper.min
//= require site/bootstrap.min
//= require site/datatables.min
//= require site/jquery.countdown
//= require site/jquery.counterup
//= require site/waypoints.min
//= require site/noframework.waypoints.min
//= require site/snap.svg-min
//= require_self

$(document).ready(function() {
  $('.max-height').height($(window).height() - 272);
});
