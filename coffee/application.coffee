define [
  'settings'
  'api'
  'search_form'
  'movie_list'
  'scroller'
], (Settings, API, SearchForm, MovieList, Scroller)->
  class MovieRama
    constructor: ->
      ## JQUERY SHORTCUTS
      $list   = $(list)
      $loader = $('footer')
      $search = $(search)
      $win    = $(window)

      INTHEATERS_LIST = new MovieList($list, API.inTheaters())
      CURRENT_LIST = INTHEATERS_LIST

      ## SCROLLING BEHAVIOUR
      SCROLLER = new Scroller(Settings.scrolling_offset)
      SCROLLER.on 'bottom', ->
        SCROLLER.setMutex()
        $loader.addClass 'show'
        CURRENT_LIST.getNext().then( ->
          SCROLLER.clearMutex()
        ).always ->
          $loader.removeClass 'show'

      ## SEARCH BEHAVIOUR
      SEARCH_FORM = new SearchForm($search)
      SEARCH_FORM.on 'query_start', (query)->
        CURRENT_LIST.xhr and CURRENT_LIST.xhr.abort()
        SEARCH_FORM.hideLoader()

      SEARCH_FORM.on 'query', (query)->
        $win.scrollTop(0)
        SEARCH_FORM.showLoader()
        if query is ''
          CURRENT_LIST = INTHEATERS_LIST
          INTHEATERS_LIST.restore()
          SEARCH_FORM.hideLoader()
        else
          CURRENT_LIST = new MovieList($list, API.search(query))
          CURRENT_LIST.then -> SEARCH_FORM.hideLoader()

      ## REGISTER HANDLERS FOR MOVIE DETAILS
      $list.on 'click', '.movie_item', CURRENT_LIST.updateElement

  return MovieRama