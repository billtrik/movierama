require ['api', 'models/movie'], (API, Movie)->
  current_cursor = API.inTheaters()

  ## GET FIRST DATA AND DRAW ELEMENTS
  current_cursor.get().then (data)->
    templates = []
    movies = []
    for movie_data in data.movies
      movie = new Movie(movie_data)
      templates.push movie.template
      movies.push movie

    $(list).append(templates.join(''))

  ## REGISTER HANDLERS FOR SCROLLING
  ## REGISTER HANDLERS FOR MOVIE DETAILS
  ## REGISTER HANDLERS FOR MOVIE SEARCH