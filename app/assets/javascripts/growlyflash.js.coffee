#= require ./growlyflash/alert
#= require ./growlyflash/listener

jQuery ->
  Growlyflash.build_shorthands()
  Growlyflash.listen_on this