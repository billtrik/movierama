define ['jquery'], ($)->
  class Scroller
    constructor: (@offset = 200)->
      @win = $(window)
      @doc = $(document)
      @mutex = false

      @callbacks = {}

      @_registerHAndlers()

    on: (e_name, callback)->
      @callbacks[e_name] ?= []
      @callbacks[e_name].push callback

    trigger: (e_name)->
      return unless @callbacks[e_name]
      cb() for cb in @callbacks[e_name]

    setMutex: -> @mutex = true
    clearMutex: -> @mutex = false

    _registerHAndlers: -> @win.on 'scroll', @_onScroll

    _reachedBottom: ->
      return false unless @doc.height() > @win.height()
      @win.scrollTop() >= @doc.height() - @win.height() - @offset

    _onScroll: =>
      return if @mutex

      return unless @_reachedBottom()

      @trigger 'bottom'

  return Scroller