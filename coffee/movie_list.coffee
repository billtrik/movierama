define [
  'jquery'
  'settings'
  'models/movie'
  'scroller'
], ($, Settings, Movie, Scroller)->
  class MovieList
    constructor: (@$el)->
      @xhr = null
      @current = null
      @cursor_list = {}

      @loader = $('footer')
      @scroller = new Scroller(Settings.scrolling_offset)

      @_registerHandlers()

    load: (type, cursor = null)->
      dfd = new $.Deferred()

      if @current
        @current.fragment = @$el.children().detach()

      if @cursor_list[type]
        @current = @cursor_list[type]
        @$el.append(@current.fragment)
        dfd.resolve()
      else
        @cursor_list[type] =
          cursor: cursor
          fragment: null

        @current = @cursor_list[type]

        @_getNext().then ->
          dfd.resolve()
        , -> dfd.reject()

      dfd

    stopLoading: -> @xhr and @xhr.abort()

    _registerHandlers: ->
      @$el.on 'click', '.movie_item', @_updateElement

      me = @
      @scroller.on 'bottom', ->
        me.scroller.setMutex()
        me.loader.addClass 'show'

        me._getNext(true)
          .then -> me.scroller.clearMutex()
          .always -> me.loader.removeClass 'show'

    _getNext: (append = false)->
      @stopLoading()

      @xhr = @current.cursor.next()
      @xhr.then (data)=>
        @xhr = null
        @_parseData(data, append)
      , @_onError

    _onError: -> console.log 'Movie List error'

    _updateElement: (e)=>
      $li = $(e.currentTarget)
      movie_instance = $li.data('_instance')

      if $li.hasClass 'details'
        return unless $(e.toElement).hasClass 'closeme'
        movie_instance.showSimple()
      else
        movie_instance.showDetailed()

      return false

    _parseData: (data, append = false)->
      templates = []

      for movie_data in data.movies
        movie = new Movie(movie_data)
        templates.push movie.$el

      if append
        @$el.append templates
      else
        @$el.html templates


  return MovieList