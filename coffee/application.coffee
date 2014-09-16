require [
  'settings'
  'api'
  'movie_list'
  'scroller'
], (Settings, API, MovieList, Scroller)->
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

  ## TODO: REGISTER HANDLERS FOR MOVIE DETAILS
  return