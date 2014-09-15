define ['settings', 'cursor'], (Settings, Cursor)->
  class API
    @_endpoints:
      inTheaters: -> {
        url: 'api/public/v1.0/lists/movies/in_theaters.json'
        params: {
          country: 'gr'
        }
      }
      search: (query)-> {
        url: 'api/public/v1.0/movies.json'
        params: {
          q: query
        }
      }
      movie: (id)-> {
        url: "api/public/v1.0/movies/#{id}.json"
        params: {}
      }
      movieReviews: (id)-> {
        url: "api/public/v1.0/movies/#{id}/reviews.json"
        params: {
          country: 'gr'
          review_type: 'all' #'top_critic|all|dvd'
          page_limit: 2
        }
      }
      movieSimilar: (id)-> {
        url: "api/public/v1.0/movies/#{id}/similar"
        params: {
          limit: 5
        }
      }

    constructor: (@apikey)->
      @_populateApiMethods(API._endpoints)


    _get: (endpoint)->
      endpoint.params.apikey = @apikey
      url = "#{Settings.api_base_url}/#{endpoint.url}"
      new Cursor(url, endpoint.params)

    _populateApiMethods: (endpoints)->
      _me = @
      for endpoint, endpoint_details of endpoints
        this[endpoint] = ((endpoint_details)->
          return -> _me._get endpoint_details.apply(_me, arguments)
        )(endpoint_details)

  return new API(Settings.api_key)