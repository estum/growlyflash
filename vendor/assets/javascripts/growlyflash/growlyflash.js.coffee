#= require growlyflash/bootstrap-growl

root = window ? this

class Growlyflash    
  constructor: (@context) ->
    @flash_log = []
    if window.flashes?
      @growl window.flashes
      delete window.flashes
    # we have to bind both of ajax-complete events
    # sometimes one of them takes messages and they are skipping
    # but in mostly, they produce duplicates :(  
    $(@context).on 'ajax:complete ajaxComplete', @ajax_complete
    
  growl: (flashes) ->
    for type, msg of flashes when msg?
      @log type: type, msg: msg
      $.bootstrapGrowl msg, type: $.bootstrapGrowl.defaults.type_mapping[type]
  
  log: (xmessage) -> @flash_log.push(xmessage)
  log_isnt_empty: -> @flash_log.length > 0
  purge_log:      -> @flash_log = []
  
  messages: (flashes) ->
    { type:type, msg:msg } for type, msg of flashes
  
  ajax_complete: (e, response, settings) =>
    flashes = @get_x_message.call response
    if flashes?
      messages = @messages flashes
      # Reduce duplicates (because binded twice)
      @reduce_duplicates messages, => 
        @growl flashes
        # To prevent reducing similar messages on
        # the next event, log should flushes after
        window.setTimeout => 
          do @purge_log
        , 100
      true
  
  # Parse encoded messages
  get_x_message: ->
    encoded = @getResponseHeader 'X-Message'
    decoded = decodeURIComponent encoded
    $.parseJSON decoded if decoded?
  
  reduce_duplicates: (messages, callback) ->
    if @log_isnt_empty()
      return @purge_log() unless @get_log_matches messages
    do callback
  
  get_log_matches: (messages) ->
    last_log = @flash_log.slice -messages.length
    not_matches = 0
    not_matches++ for id, f of messages when (last_log[id].type isnt f.type) and (last_log[id].msg isnt f.msg)
    not_matches > 0

root.Growlyflash = Growlyflash

$ ->
  root.growly = new Growlyflash document unless root.growly