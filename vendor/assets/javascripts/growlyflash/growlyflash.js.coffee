#= require growlyflash/bootstrap-growl

root = window ? this

class Growlyflash
  TYPE_MAPPING =
    warning: null
    error  : 'error'
    notice : 'info'
    success: 'success'
    
  constructor: (@context) ->
    @flash_log = []
    @growl window.flashes if window.flashes?
    $(@context).on 'ajax:complete ajaxComplete', @ajax_complete
    
  growl: (flashes) ->
    for type, msg of flashes when msg?
      @log type:type, msg:msg
      $.bootstrapGrowl msg, type: TYPE_MAPPING[type]
  
  log: (xmessage) -> @flash_log.push(xmessage)
  log_is_not_empty: -> @flash_log.length > 0
  purge_log: -> 
    @flash_log = []
    true
  
  messages: (flashes) ->
    { type:type, msg:msg } for type, msg of flashes
  
  ajax_complete: (e, response, settings) =>
    if flashes = @get_x_message.call response
      messages = @messages flashes
      @reduce_duplicates messages, => @growl flashes
      true
  
  get_x_message: ->
    encoded = @getResponseHeader 'X-Message'
    decoded = decodeURIComponent encoded
    $.parseJSON decoded if decoded?
  
  reduce_duplicates: (messages, callback) ->
    if @log_is_not_empty()
      return @purge_log unless @get_log_matches messages
    do callback
  
  get_log_matches: (messages) ->
    last_log = @flashes_log.slice -messages.length
    not_matches = 0
    not_matches++ for id, f of messages when (last_log[id].type isnt f.type) and (last_log[id].msg isnt f.msg)
    not_matches > 0

root.Growlyflash = Growlyflash

jQuery ->
  new Growlyflash document