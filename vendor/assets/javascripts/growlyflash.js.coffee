#= require growlyflash/bootstrap-growl

class Growlyflash
  HEADER: 'X-Message'
  EVENTS: 'ajax:complete ajaxComplete'  
  
  class FlashObject
    @build: (flashes = {}) -> 
      new this(type, msg) for type, msg of flashes when msg?
    
    @from_request: (req) ->
      decoded = (decodeURIComponent req.getResponseHeader Growlyflash::HEADER)
      if decoded? then (@build $.parseJSON decoded) else []
    
    constructor: (@type, @msg) -> @shown = no
    
    growl: ->
      $.bootstrapGrowl @msg, type: @_alert_type()
      @shown = yes
      return this
    
    is_equal: (o) -> (@type is o.type) and (@msg is o.msg)
    isnt_equal: (o) -> (not is_equal o)
    _alert_type: -> $.bootstrapGrowl.defaults.type_mapping[@type]
  
  class FlashStack extends Array    
    purge: ->
      removed = (@splice 0)
      console.log "FlashStack removes #{removed}. Result: #{this}"
      return this
    
    has_uniq_from: (ary, cnt = 0) ->
      return true if @is_empty()
      recent = (@slice -ary.length)
      cnt++ for id, item of ary when (recent[id].isnt_equal item)
      return cnt > 0
    
    is_empty: -> not (@length > 0)
  
  stack = null
  
  growl = (flashes) ->
    stack.push flash.growl() for flash in flashes
    return
  
  reduce_dups = (flashes, callback) ->
    if stack.has_uniq_from(flashes) then callback(flashes) else stack.purge()
  
  constructor: (context) ->
    stack ?= new FlashStack()
    
    if window.flashes?
      growl FlashObject.build(window.flashes)
      delete window.flashes
    
    ($ context).on @EVENTS, (e, req) ->
      flashes = FlashObject.from_request(req)
      reduce_dups flashes, ->
        growl flashes
        setTimeout (-> stack.purge()), 100
      return


window.Growlyflash ?= Growlyflash

jQuery ->
  window.growly ?= new Growlyflash(document)
  return