#= require growlyflash/bootstrap-growl

# unless $.Growlyflash then $.Growlyflash = $.bootstrapGrowl

root = global ? window

class Growlyflash
  TYPE_MAPPING =
    warning: null
    error  : 'error'
    notice : 'info'
    success: 'success'

  constructor: (@context) ->
    @growl(window.flashes) if window.flashes?
    $(@context).on 'ajax:complete ajaxComplete', @ajax_complete
    
  growl: (flashes) ->
    for type, msg of flashes when msg?
      $.bootstrapGrowl msg, type: TYPE_MAPPING[type]
  
  messages: (flashes) ->
    { type:type, msg:msg } for type, msg of flashes
  
  ajax_complete: (e, response, settings) =>
    xmessage = @get_x_message.call response
    if xmessage?
      flashes  = $.parseJSON xmessage
      @growl flashes
    true
  
  get_x_message: ->
    encoded = @getResponseHeader('X-Message')
    decodeURIComponent encoded
    

root.Growlyflash = Growlyflash

jQuery ->
  growlyflash = new Growlyflash document