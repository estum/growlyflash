# https://github.com/ifightcrime/bootstrap-growl

$ = jQuery

old = $.bootstrapGrowl

$.bootstrapGrowl = (message, options) ->
  settings = $.extend {}, $.bootstrapGrowl.defaults, options

  html_attrs = 
    class: 'bootstrap-growl alert'
    html: ''
  html_attrs.class += " alert-#{settings.type}" if settings.type?
  html_attrs.html += """<a class="close" data-dismiss="alert" href="#">&times;</a>""" if settings.can_dismiss
  html_attrs.html += message

  DivAlert = $ '<div />', html_attrs

  # calculate any 'stack-up'
  offset = settings.offset.amount
  $(".bootstrap-growl").each ->
    offset_from  = parseInt $(@).css settings.offset.from
    height = $(@).outerHeight()
    offset = Math.max offset, offset_from + height + settings.spacing

  DivAlert.css
    position: (if settings.target is 'body' then 'fixed' else 'absolute')
    margin: 0
    zIndex: 9999
    display: 'none'
    width: (if settings.width isnt 'auto' then "#{settings.width}px" else 'auto')

  DivAlert.css settings.offset.from, "#{offset}px"

  # have to append before we can use outerWidth()
  $(settings.target).append DivAlert

  DivAlert.css switch settings.align
    when "center" then left: '50%', marginLeft:"-#{DivAlert.outerWidth() / 2}px"
    when "left"   then left: '20px'
    else right: '20px'
  DivAlert.fadeIn()

  # Only remove after delay if delay is more than 0
  if settings.delay > 0
    DivAlert.delay(settings.delay).fadeOut -> $(@).remove()

  @

$.bootstrapGrowl.defaults = 
  width:    250
  delay:    4000
  spacing:  10  
  target:   'body'
  align:    'right'
  dismiss:  true
  type:     null
  offset:   
    from:   'top'
    amount: 20

$.bootstrapGrowl.noConflict = ->
  $.bootstrapGrowl = old
  @