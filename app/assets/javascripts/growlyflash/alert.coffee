class Growlyflash
window.Growlyflash ?= Growlyflash

Growlyflash.defaults =
  align:   'right'  # horizontal aligning (left, right or center)
  delay:   4000     # auto-dismiss timeout (0 to disable auto-dismiss)
  dismiss: yes      # allow to show close button
  spacing: 10       # spacing between alerts
  target:  'body'   # selector to target element where to place alerts
  title:   no       # switch for adding a title
  type:    null     # bootstrap alert class by default
  class:   ['alert', 'growlyflash', 'fade']

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
    {@title, @align, @delay, @dismiss, @msg, @spacing, @target, @type, @class} = options
    
    @el = ($ '<div>', class: @_classes().join(' '), html: "#{@_dismiss()}#{@_title()}#{@msg}").appendTo(@target)
    @el.css(@_calc_position()).toggleClass('in')
    @el.delay(@delay).fadeOut(-> ($ @).remove()) if @delay > 0
  
  _classes: -> 
    @class.concat ("alert-#{type}" for type in [@type] when type?), ["growlyflash-#{@align}"]
  
  _dismiss: ->
    return "" unless @dismiss?
    """<a class="close" data-dismiss="alert" href="#">&times;</a>"""
  
  _title: ->
    return "" unless @title?
    """<strong>#{@type.charAt(0).toUpperCase()}#{@type.substring(1)}!</strong>"""
  
  _calc_offset: ->
    amount = parseInt(@el.css 'top')
    (@el.siblings '.growlyflash').each (_, el) =>
      amount = Math.max(amount, parseInt(($ el).css 'top') + ($ el).outerHeight() + @spacing)
    amount
  
  _calc_position: ->
    styles = {}
    styles.top = "#{@_calc_offset()}px"
    styles.marginLeft = "-#{@el.outerWidth() / 2}px" if @align is 'center'
    styles

$.growlyflash = (flash, options = {}) ->
  settings = $.extend(on, {}, Growlyflash.defaults, msg: flash.msg, type: flash.type, options)
  alert = new Growlyflash.Alert(flash, settings)
  if flash instanceof Growlyflash.FlashStruct then flash else alert
