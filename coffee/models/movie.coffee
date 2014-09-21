define ['templates/movie', 'lodash', 'API'], (template, _, API)->
  class Movie
    constructor: (data)->
      @id = data.id
      @data = @_prepareInitialData(data)
      @hasUpdatedData = false

      @$el = $(template.layout({content: template.simple(@data)}))

      @$el.data '_instance', @

    showSimple: ->
      @$el.removeClass 'details'
      @$el.html $(template.simple(@data))

    showDetailed: ->
      dfd = new $.Deferred()
      dfd.then =>
        @$el.addClass 'details'
        @$el.html $(template.detailed(@data))

      if @hasUpdatedData
        dfd.resolve()
      else
        @$el.addClass 'loading'
        @$el.append $(template.loader())
        @updateDetails().then =>
          @$el.removeClass 'loading'
          dfd.resolve()

      dfd

    updateDetails: ->
      dfd = new $.Deferred()

      $.when(
        API.movie(@id).get()
        API.movieReviews(@id).get(2)
        API.movieSimilar(@id).get()
      ).then (details, reviews, similar)=>
        @_parseDetailsData(details, reviews, similar)
        dfd.resolve()
      , @_onDetailsError

      dfd

    _onDetailsError: (xhr)=>
      console.log 'On Movie Details error'
      @$el.removeClass 'loading'
      @showSimple()

    _parseDetailsData: (details, reviews, similar)=>
      details = @_prepareDetailsData(details[0])
      reviews = @_prepareReviewsData(reviews[0])
      similar = @_prepareSimilarData(similar[0])

      @data = $.extend @data, details
      @data.similar_partial = template.similar_partial(similar)
      @data.reviews_partial = template.reviews_partial(reviews)

      @hasUpdatedData = true

    _prepareInitialData: (data)->
      actors = _.map data.abridged_cast, (actor, index)-> if index < 3 then actor.name else false

      return {
        poster       : data.posters.original or null #no_image
        title        : data.title or ''
        synopsis     : data.synopsis or 'No synopsis available'
        release_date : data.release_dates.theater or data.release_dates.dvd or null
        runtime      : data.runtime or null
        rating       : data.ratings.critics_score or null
        cast         : _.compact(actors)
      }

    _prepareReviewsData: (data)->
      reviews: _.map data.reviews, (review, index)->
        critic: review.critic or 'No Critic data'
        date: review.date or 'No Review Date data'
        quote: review.quote or 'No Quote data'


    _prepareSimilarData: (data)->
      similar: _.map data.movies, (movie, index)->
        title: movie.title or 'No Title data'
        url: movie.links.alternate or null

    _prepareDetailsData: (data)->
      genre: data.genres.join(', ') or 'No Genre data'
      director: data.abridged_directors[0].name or 'No Director data'