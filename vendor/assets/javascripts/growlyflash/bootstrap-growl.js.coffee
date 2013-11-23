# https://github.com/ifightcrime/bootstrap-growl

do ($ = jQuery) ->
  old = $.bootstrapGrowl
  
  alert_classes_add = (list...) -> 
    ['bootstrap-growl', 'alert'].concat("alert-#{type}" for type in list when type?)

  icon_classes_add = (list...) ->
    ['glyphicon'].concat("glyphicon-#{type}" for type in list when type?)
  
  css_metrics_val = (val) ->
    str = "#{val ? 0}"
    str += "px" if /\d$/.test str
    str
  
  $.bootstrapGrowl = (message, options) ->
    {width, delay, spacing, target, align, alignAmount, dismiss, type, offset, icon} = $.extend({}, $.bootstrapGrowl.defaults, options)
    width = css_metrics_val width
    alignAmount = css_metrics_val alignAmount
    
    box_alert = $ """
                  <div class="#{alert_classes_add(type).join(" ")}">
                    <span class="#{icon_classes_add(icon).join(" ")}"></span>
                    #{'<a class="close" data-dismiss="alert" href="#">&times;</a>' if dismiss}
                    #{message}
                  </div>
                  """
    
    # calculate any 'stack-up'
    $(".bootstrap-growl").each ->
      height = $(@).outerHeight()
      _from   = parseInt $(@).css offset.from
      offset.amount = Math.max offset.amount, _from + height + spacing
    
    box_alert.css offset.from, css_metrics_val(offset.amount)
    box_alert.css 
      position: (if target is 'body' then 'fixed' else 'absolute')
      width:    width
      display: 'none'
      zIndex:   9999
      margin:   0
    
    $(target).append box_alert
    box_alert.css switch align
      when "center" then left: '50%', marginLeft: "-#{box_alert.outerWidth() / 2}px"
      when "left"   then left: alignAmount 
      else right: alignAmount
    
    box_alert.fadeIn()
    # Only remove after delay if delay is more than 0
    box_alert.delay(delay).fadeOut(-> $(@).remove()) if delay > 0
    
    return this
  
  
  $.bootstrapGrowl.defaults = 
    # Width of the box (number or css-like string, etc. "auto")
    width:       250
    
    # Auto-dismiss timeout. Set it to 0 if you want to disable auto-dismiss
    delay:       4000
    
    # Spacing between boxes in stack
    spacing:     10
    
    # Appends boxes to a specific container
    target:      'body'
    
    # Show close button
    dismiss:     true
    
    # Default class suffix for alert boxes. 
    # Use the following mapping (Flash key => Bootstrap Alert)
    #   warning: null
    #   error:   "error"
    #   notice:  "info"
    #   success: "success"
    type:        null
    
    # Horizontal aligning (left, right or center)
    align:       'right'
    
    # Margin from the closest side
    alignAmount: 20
    
    # Offset from window bounds
    offset:      
      from:      'top'
      amount:    20

  
  $.bootstrapGrowl.noConflict = ->
    $.bootstrapGrowl = old
    return this
  
  return this