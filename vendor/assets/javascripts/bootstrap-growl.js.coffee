# https://github.com/ifightcrime/bootstrap-growl

$ = jQuery

$.extend
  bootstrapGrowl: (message, options) ->
    settings =
      ele: 'body'
      type: null
      offset: from:'top',  amount:20
      align: "right"
      width: 250
      delay: 4000
      allow_dismiss: true
      stackup_spacing: 10
    
    settings = $.extend settings, options
  
    html_attrs = 
      class: 'bootstrap-grow alert'
      html: ''
    html_attrs.class += "alert-#{settings.type}" if settings.type?
    html_attrs.html += """<a class="close" data-dismiss="alert" href="#">&times;</a>""" if settings.allow_dismiss
    html_attrs.html += message
  
    $alert = $ '<div />', html_attrs

    # Prevent BC breaks
    if settings.top_offset?
      settings.offset = from:'top',  amount:settings.top_offset

    # calculate any 'stack-up'
    offsetAmount = settings.offset.amount
    $(".bootstrap-growl").each ->
      offsetAmount = Math.max(offsetAmount, parseInt($(@).css(settings.offset.from)) + $(@).outerHeight() + settings.stackup_spacing)

    $alert.css
      "#{settings.offset.from}": "#{offsetAmount}px"
      position: ((settings.ele == 'body') ? 'fixed' : 'absolute')
      margin: 0
      zIndex: 9999
      display: 'none'
      width: ((settings.width != 'auto') ? "#{settings.width}px" : 'auto')

    # have to append before we can use outerWidth()
    $(settings.ele).append $alert
    $alert.css switch settings.align
      when "center" then left:'50%', marginLeft:"-#{($alert.outerWidth() / 2)}px"
      when "left"   then left:'20px'
      else right:'20px'
    $alert.fadeIn()

    # Only remove after delay if delay is more than 0
    if settings.delay > 0
      $alert.delay(settings.delay).fadeOut -> $(@).remove()