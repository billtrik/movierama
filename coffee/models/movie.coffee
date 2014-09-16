define ['templates/movie', 'lodash'], (template, _)->
  class Movie
    constructor: (data)->
      actors = _.map data.abridged_cast, (actor, index)-> if index < 3 then actor.name else false

      @data =
        poster       : data.posters.original or null #no_image
        title        : data.title or ''
        synopsis     : data.synopsis or 'No synopsis available'
        release_date : data.release_dates.theater or data.release_dates.dvd or null
        runtime      : data.runtime or null
        rating       : data.ratings.critics_score or null
        cast         : _.compact(actors)

      @el = null

    template: -> _.template(template, @data)

