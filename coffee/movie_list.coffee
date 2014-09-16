define ['jquery', 'models/movie'], ($, Movie)->
  class MovieList
    constructor: (@$el, @cursor)->
      @movies = []
      @xhr = null

      @getNext(true)

    then: (success, fail)-> @xhr.then(success, fail)

    getNext: (replace = false)->
      @xhr and @xhr.abort()

      @xhr = @cursor.next()
      @xhr.then (data)=>
        @_printMovies(data, replace)
      , @_onError

    _onError: -> console.log 'Movie List error'

    _printMovies: (data, replace = false)->
      @xhr = null

      templates = []
      if replace
        ## TODO CLEANUP
        @movies = []

      for movie_data in data.movies
        movie = new Movie(movie_data)
        templates.push movie.template()
        @movies.push movie

      if replace
        @$el.html(templates.join(''))
      else
        @$el.append(templates.join(''))

  return MovieList