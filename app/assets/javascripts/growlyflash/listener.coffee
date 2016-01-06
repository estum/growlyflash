class Growlyflash.Listener
  # Alerts stack
  class Stack
    constructor: (@items...) ->

    purge: ->
      setTimeout (=> @items.splice(0)), 100

    push: (alert, dumped) ->
      dumped ?= alert.toString()
      console.log("Add to Growlyflash stack: ", dumped) if Growlyflash.debug
      Growlyflash.growl(alert)
      @items.push(dumped)

    push_only_fresh: (alerts) ->
      recent = @items[-alerts.length..]
      for alert in alerts
        dumped = alert.toString()
        @push(alert, dumped) if dumped not in recent
      do @purge

  HEADER = 'X-Message'
  EVENTS = 'ajax:complete ajaxComplete'

  process = (alerts = {}) ->
    new Growlyflash.FlashStruct(msg, type) for type, msg of alerts when msg?

  process_from_header = (source) ->
    return [] unless source?
    process $.parseJSON(decodeURIComponent(source))

  constructor: (context) ->
    @stack ?= new Stack()
    @process_static() if window.flashes?
    ($ context).on EVENTS, (_, xhr) =>
      @stack.push_only_fresh process_from_header(xhr.getResponseHeader(HEADER))

  process_static: ->
    @stack.push alert for alert in process(window.flashes)
    delete window.flashes

Growlyflash.listen_on = (context) ->
  @listener ?= new @Listener(context)