define [
  'api'
  'search_form'
  'movie_list'
], (API, SearchForm, MovieList)->
  class MovieRama
    constructor: ->
      $search = $(search)
      $win    = $(window)

      list = new MovieList $('#list')
      list.load('in_theaters', API.inTheaters())

      search_form = new SearchForm($search)
      search_form.on 'query_start', (query)->
        list.stopLoading()
        search_form.hideLoader()

      search_form.on 'query', (query)->
        $win.scrollTop(0)
        search_form.showLoader()
        if query is ''
          list.load('in_theaters')
          search_form.hideLoader()
        else
          list.load("search_#{query}", API.search(query)).then ->
            search_form.hideLoader()

  return MovieRama