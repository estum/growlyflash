#= require growlyflash/bootstrap-growl

# unless $.Growlyflash then $.Growlyflash = $.bootstrapGrowl

root = global ? window

class Growlyflash
  TYPE_MAPPING =
    warning: null
    error  : 'error'
    notice : 'info'
    success: 'success'

  constructor: () ->
    # @flashes_log = []
    @growl(window.flashes) if window.flashes?
    $(document).on 'ajax:complete', @ajax_complete
    $(document).ajaxComplete @ajax_complete
    
  growl: (flashes) ->
    for type, msg of flashes when msg?
      $.bootstrapGrowl msg, type: TYPE_MAPPING[type]
      # @flashes_log.push type:type, msg:msg
  
  messages: (flashes) ->
    { type:type, msg:msg } for type, msg of flashes

  ajax_complete: (e, req) =>
    xmessage = req.getResponseHeader 'X-Message'
    console.log xmessage, e
    flashes = $.parseJSON xmessage
    @growl flashes
    true
    # return false if $.isEmptyObject flashes    
    # messages = @messages flashes
    # if @flashes_log.length > 0
    #   last_log    = @flashes_log.slice( - messages.length )
    #   not_matches = 0
    #   not_matches++ for id, f of messages when (last_log[id].type isnt f.type) and (last_log[id].msg isnt f.msg)
    #   unless not_matches > 0
    #     @flashes_log = []
    #     return true
    # $.merge @flashes_log, messages

root.Growlyflash = Growlyflash

jQuery ->
  new Growlyflash()