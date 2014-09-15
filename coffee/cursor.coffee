define ['jquery'], ($)->
  class Cursor
    @_cursor_defaults:
      page:  0
      page_limit:  10

    constructor: (@url, @params)->
      @state = $.extend {}, Cursor._cursor_defaults, @params

    get: (page_limit = null)->
      return @next() unless @state.page is 0 or page_limit isnt null

      @state.page = 1
      @state.page_limit = page_limit or 10
      @_ajax(@url, @state)

    next: ->
      return @get() if @state.page is 0

      @state.page += 1
      @_ajax(@url, @state)

    _ajax: (url, data)-> $.ajax
      url: url
      method: 'GET'
      dataType: 'jsonp'
      data: data


  return Cursor