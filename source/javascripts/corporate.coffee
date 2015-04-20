//= require jquery
//= require vendor/fastclick
//= require vendor/jquery.appear
//= require vendor/TweenMax.min
//= require_self
//= require_tree ./corporate

window.Corporate ||= {}

$ ->
  FastClick.attach(document.body)
  new Corporate.Header
  
