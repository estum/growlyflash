class Growlyflash
  @defaults =
    align:   'right'  # horizontal aligning (left, right or center)
    delay:   4000     # auto-dismiss timeout (false to disable auto-dismiss)
    dismiss: yes      # allow to show close button
    spacing: 10       # spacing between alerts
    target:  'body'   # selector to target element where to place alerts
    title:   no       # switch for adding a title
    type:    null     # bootstrap alert class by default
    class:   ['alert', 'growlyflash', 'fade']

    # customizable callback to set notification position before it shows
    before_show: ->
      @el.css @calc_css_position()

  @KEY_MAPPING =
    alert:   'warning'
    error:   'danger'
    notice:  'info'
    success: 'success'

  @DISMISS = """<button type="close" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>"""

  _titleize = (s) -> s.replace /^./, (m) -> do m.toUpperCase

  h = @helpers =
    dismiss: -> Growlyflash.DISMISS
    title: (s) -> "<strong>#{_titleize(s)}!</strong> "

  # Flash message struct
  class @FlashStruct
    toString: -> JSON.stringify "#{@msg}": @key
    constructor: (@msg, @key) ->
      @type = Growlyflash.KEY_MAPPING[@key]

  class @Alert
    _add = (orig, add) -> @splice -~@indexOf(orig), 0, "#{orig}-#{add}"
    _top = (e) -> parseInt ($ e).css('top')

    constructor: (@flash, @opts) ->
      {title, target, dismiss, delay, before_show} = @opts

      html = ""
      html += h.dismiss() if dismiss
      html += h.title(@opts) if title
      html += @flash.msg

      @el = ($ '<div>', html: html, class: @class_list().join(' '), role: "alert")
      @el.appendTo(target)

      before_show?.call(this)
      @show()
      setTimeout(@close, @opts.delay) if delay

    class_list: ->
      list = [].concat(@opts.class)
      add = _add.bind(list)
      add 'alert', "dismissable"     if @opts.dismiss
      add 'alert', @opts.type        if @opts.type?
      add 'growlyflash', @opts.align if @opts.align?
      list

    show:  => @el.toggleClass('in', on)
    close: => @el.alert?('close')

    calc_top_offset: ({spacing}) ->
      amount = _top(@el)
      (@el.siblings '.growlyflash').each ->
        amount = Math.max(amount, _top(@) + ($ @).outerHeight() + spacing)
      return amount

    calc_css_position: (css = {}) ->
      css.top        = "#{@calc_top_offset(@opts)}px"
      css.marginLeft = "-#{@el.outerWidth() / 2}px" if @opts.align is 'center'
      css

window.Growlyflash = Growlyflash

$.growlyflash = (flash, options = {}) ->
  options = $.extend on, {}, Growlyflash.defaults, type: flash.type, options
  alert   = new Growlyflash.Alert(flash, options)
  if flash instanceof Growlyflash.FlashStruct then flash else alert
