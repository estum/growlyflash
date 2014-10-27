# https://github.com/ifightcrime/bootstrap-growl

do ($ = jQuery) ->
  class BootstrapGrowl
    alert_classes_add = (list...) -> 
      ['bootstrap-growl', 'alert'].concat("alert-#{type}" for type in list when type?)
    
    cssval = (val) ->
      str = "#{val ? 0}"
      str += "px" if /\d$/.test str
      str
    
    constructor: (@message, @options) ->
      @alert = ($ do @_build_alert)
      @alert.css(do @_alert_styles)
      @alert.appendTo(@options.target)
      @alert.css(do @_alert_position)
      @alert.fadeIn()
      if @options.delay > 0
        @alert.
          delay(@options.delay).
          fadeOut -> ($ @).remove()
      # body...
    
    _build_alert: ->
      """
      <div class="#{(alert_classes_add @options.type).join(' ')}">
        #{@_dismiss()}#{@message}
      </div>
      """
    
    _dismiss: ->
      if @options.dismiss then """<a class="close" data-dismiss="alert" href="#">&times;</a>""" else ""
    
    _calc_offset: ->
      spacing = @options.spacing
      {from, amount} = @options.offset
      ($ ".bootstrap-growl").each ->
        amount = Math.max(amount, parseInt(($ @).css(from)) + ($ @).outerHeight() + spacing)
      amount
    
    _alert_styles: ->
      styles = 
        position: (if @options.target is 'body' then 'fixed' else 'absolute')
        width:    (cssval @options.width)
        display: 'none'
        zIndex:   9999
        margin:   0
      styles[@options.offset.from] = (cssval @_calc_offset())
      styles
    
    _alert_position: ->
      styles = {}      
      switch @options.align
        when "center"
          styles.left = '50%'
          styles.marginLeft = "-#{@alert.outerWidth() / 2}px"
        when "left", "right"
          styles[@options.align] = (cssval @options.alignAmount)
      styles
  
  old = $.bootstrapGrowl
  
  $.bootstrapGrowl = (message, options) ->
    # {width, delay, spacing, target, align, alignAmount, dismiss, type, offset}
    settings = $.extend(on, {}, $.bootstrapGrowl.defaults, options)    
    new BootstrapGrowl(message, settings)
  
  
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
    type:        null
    
    # Use the following mapping (Flash key => Bootstrap Alert)
    type_mapping:
      warning: null
      error  : 'error'
      notice : 'info'
      success: 'success'
    
    # Horizontal aligning (left, right or center)
    align:       'right'
    
    # Margin from the closest side
    alignAmount: 20
    
    # Offset from window bounds
    offset:      
      from:      'top'
      amount:    20
  
  $.bootstrapGrowl.Constructor = BootstrapGrowl
  
  $.bootstrapGrowl.noConflict = ->
    $.bootstrapGrowl = old
    return
  
  return