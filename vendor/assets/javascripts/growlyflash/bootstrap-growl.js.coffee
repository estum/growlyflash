# https://github.com/ifightcrime/bootstrap-growl

$ = jQuery

old = $.bootstrapGrowl

$.bootstrapGrowl = (message, options) ->
  settings = $.extend {}, $.bootstrapGrowl.defaults, options
  
  box_classes = ["bootstrap-growl", "alert"]
  box_classes.push "alert-#{settings.type}" if settings.type?
  
  box_alert = jQuery  """
                      <div class="#{box_classes.join(' ')}">
                        #{'<a class="close" data-dismiss="alert" href="#">&times;</a>' if settings.dismiss}
                        #{message}
                      </div>
                      """
  
  # calculate any 'stack-up'
  offset = settings.offset.amount
  $(".bootstrap-growl").each ->
    offset_from  = parseInt $(@).css settings.offset.from
    height = $(@).outerHeight()
    offset = Math.max offset, offset_from + height + settings.spacing
  
  box_alert.css
    position: (if settings.target is 'body' then 'fixed' else 'absolute')
    margin: 0
    zIndex: 9999
    display: 'none'
    width: (if settings.width isnt 'auto' then "#{settings.width}px" else 'auto')

  box_alert.css settings.offset.from, "#{offset}px"

  # have to append before we can use outerWidth()
  $(settings.target).append box_alert

  box_alert.css switch settings.align
    when "center" then left: '50%', marginLeft:"-#{box_alert.outerWidth() / 2}px"
    when "left"   then left: '20px'
    else right: '20px'
  box_alert.fadeIn()

  # Only remove after delay if delay is more than 0
  if settings.delay > 0
    box_alert.delay(settings.delay).fadeOut -> $(@).remove()
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