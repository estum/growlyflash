class Growlyflash.Listener
  HEADER = 'X-Message'
  EVENTS = 'ajax:complete ajaxComplete'
  
  # Alerts stack
  class Stack extends Array
    constructor: (items...) ->
      @splice 0, 0, items...
    has_uniq_in: (alerts, counter = 0) ->
      return true unless @length > 0
      recent = @slice -alerts.length
      counter++ for id, item of alerts when recent[id].isnt_equal? item
      counter > 0
    push_all: (alerts) ->
      @push alert.growl() for alert in alerts
      this
    push_once: (alerts) ->
      @push_all alerts if @has_uniq_in alerts
      @purge()
    purge: ->
      setTimeout (=> @splice 0), 100
  
  process = (alerts = {}) ->
    new Growlyflash.FlashStruct(msg, type) for type, msg of alerts when msg?
  
  process_from_header = (source) ->
    return [] unless source?
    process $.parseJSON(decodeURIComponent source)
  
  constructor: (context) ->
    @stack ?= new Stack()
    @process_static() if window.flashes?
    ($ context).on EVENTS, (_, xhr) =>
      @stack.push_once process_from_header(xhr.getResponseHeader HEADER)
      return
  process_static: ->
    @stack.push_all process(window.flashes)
    delete window.flashes

Growlyflash.listen_on = (context) ->
  @listener ?= new @Listener(context)