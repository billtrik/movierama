define ['jquery'], ($)->
  class SearchForm
    constructor: (@$input)->
      @$form = @$input.closest('form')
      @$timeout_bar = $('#timeout_bar')
      @$loader = @$form.find('.progress')

      @timeout = null
      @last_query = ''
      @callbacks = {}

      @registerHandlers()

    on: (event_name, callback)->
      @callbacks[event_name] ?= []
      @callbacks[event_name].push callback

    trigger: (event_name, data...)->
      return unless @callbacks[event_name]
      cb.apply(null, data) for cb in @callbacks[event_name]

    registerHandlers: ->
      @$form
        .on('submit', -> return false)
        .on 'reset', => @$input.val('').trigger('keyup')

      @$input.on 'keyup', @_onKeyUp

    hideTimeoutBar: ->
      @$timeout_bar.addClass('notransition').removeClass 'show'
      ## Trigger reflow to force reset of CSS transition
      @$timeout_bar[0].offsetWidth = @$timeout_bar[0].offsetWidth;

    showTimeoutBar: ->
      @$timeout_bar.removeClass('notransition').addClass 'show'

    hideLoader: -> @$loader.removeClass 'show'

    showLoader: -> @$loader.addClass 'show'

    _onKeyUp: (e)=>
      query = $(e.currentTarget).val().trim()
      return if @last_query is query

      @last_query = query

      ## Cleanup
      clearTimeout(@timeout)
      @hideTimeoutBar()

      @trigger 'query_start'
      if query is ''
        @trigger 'query', query
      else
        _me = @
        @showTimeoutBar()
        @timeout = setTimeout ((query)->
          return ->
            _me.hideTimeoutBar()
            _me.trigger 'query', query
        )(query)
        , 600

  return SearchForm