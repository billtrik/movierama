require ['api', 'models/movie', 'scroller'], (API, Movie, Scroller)->
  current_cursor = API.inTheaters()

  get_movies = ->
    current_cursor.get().then (data)->
      templates = []
      movies = []
      for movie_data in data.movies
        movie = new Movie(movie_data)
        templates.push movie.template
        movies.push movie

      $(list).append(templates.join(''))
  loading = -> $('footer').addClass 'show'
  loaded = -> $('footer').removeClass 'show'

  ## GET FIRST DATA AND DRAW ELEMENTS
  get_movies()

  ## REGISTER HANDLERS FOR SCROLLING
  scroller = new Scroller(400)
  scroller.on 'bottom', ->
    scroller.setMutex()
    loading()
    get_movies().then ->
      scroller.clearMutex()
      loaded()

  ## REGISTER HANDLERS FOR MOVIE DETAILS
  ## REGISTER HANDLERS FOR MOVIE SEARCH