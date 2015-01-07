class Growlyflash
window.Growlyflash ?= Growlyflash

Growlyflash.defaults =
  align:   'right'  # horizontal aligning (left, right or center)
  delay:   4000     # auto-dismiss timeout (false to disable auto-dismiss)
  dismiss: yes      # allow to show close button
  spacing: 10       # spacing between alerts
  target:  'body'   # selector to target element where to place alerts
  title:   no       # switch for adding a title
  type:    null     # bootstrap alert class by default
  class:   ['alert', 'growlyflash', 'fade']
  
  # customizable callback to set notification position before it shows
  before_show: (options) -> 
    @el.css @calc_css_position()

Growlyflash.KEY_MAPPING =
  alert:   'warning'
  error:   'danger'
  notice:  'info'
  success: 'success'

class Growlyflash.FlashStruct
  shown: no
  constructor: (@msg, @key) -> @type = Growlyflash.KEY_MAPPING[@key]
  growl: -> $.growlyflash this
  is_equal: (other) -> (@key is other.key) and (@msg is other.msg)
  isnt_equal: (other) -> not @is_equal other

class Growlyflash.Alert
  constructor: (@flash, options) ->
    {@title, @align, @dismiss, @msg, @spacing, @type, @class} = options
    
    @el = ($ '<div>', 
      class: @_classes().join(' ')
      html: "#{@_dismiss()}#{@_title()}#{@msg}"
    ).appendTo(options.target)
    
    options.before_show.call(this, options)
    @show()
    
    return unless options.delay
    setTimeout => 
      @hide -> ($ @).remove()
    , options.delay
  
  show: -> @el.toggleClass 'in'
  hide: (fn) -> @el.fadeOut(fn)
  
  _classes: -> 
    @class.concat ("alert-#{type}" for type in [@type] when type?), ["growlyflash-#{@align}"]
  
  _dismiss: ->
    return "" unless @dismiss?
    """<a class="close" data-dismiss="alert" href="#">&times;</a>"""
  
  _title: ->
    return ""  if @title is no
    """<strong>#{@type.charAt(0).toUpperCase()}#{@type.substring(1)}!</strong>"""
  
  calc_top_offset: ->
    amount = parseInt(@el.css 'top')
    (@el.siblings '.growlyflash').each (_, el) =>
      amount = Math.max(amount, parseInt(($ el).css 'top') + ($ el).outerHeight() + @spacing)
    amount
  
  calc_css_position: ->
    css = {}
    css.top        = "#{@calc_top_offset()}px"
    css.marginLeft = "-#{@el.width() / 2}px" if @align is 'center'
    css

$.growlyflash = (flash, options = {}) ->
  settings = $.extend on, {}, Growlyflash.defaults, msg: flash.msg, type: flash.type, options
  alert = new Growlyflash.Alert(flash, settings)
  if flash instanceof Growlyflash.FlashStruct then flash else alert
