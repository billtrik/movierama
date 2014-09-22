define ['lodash'], (_)->
  layout = """<li class="movie_item"><%= content %></li>"""

  simple = """
    <img src='<%= poster %>'>
    <h1><%= title %></h1>
    <p class='info'><%= release_date %>, <%= runtime %> mins, <%= rating %>/100</p>
    <p class="cast"><span>Cast:</span> <%= _.forEach(cast, function(name) { name }) %></p>
    <p class="summary"><%= synopsis %></p>"""

  loader = """<div class="overlay"><div class="large progress"><span>Loading…</span></div></div>"""

  detailed = """
    <a href='#' class='closeme'>&times;</a>
    <img src='<%= poster %>'>
    <h1><%= title %></h1>
    <p class='genre'><%= genre %></p>
    <p class='info'><%= release_date %>, <%= runtime %> mins, <%= rating %>/100</p>
    <p class="summary"><%= synopsis %></p>
    <p class="director"><span>Director:</span> <%= director %></p>
    <p class="cast"><span>Cast:</span> <%= _.forEach(cast, function(name) { name }) %></p>
    <div class="similar">
      <p class="Similar"><span>Similar Movies:</span></p>
      <%= similar_partial %>
    </div>
    <div class="reviews">
      <h2>Latest Reviews</h2>
      <%= reviews_partial %>
    </div>"""

  similar_partial = """
    <dl>
    <% if(similar.length === 0) { %>
      <dt>No similar movies available</dt>
    <% } else { %>
    <% _.forEach(similar, function(movie) { %>
      <dt><a href="<%= movie.url || '#'%>" target="_blank"><%= movie.title %></a></dt>
    <% }) %>
    <% } %>
    </dl>
  """

  reviews_partial = """
    <ul>
    <% if(reviews.length === 0) { %>
      <li><p>No reviews available</p></li>
    <% } else { %>
    <% _.forEach(reviews, function(review) { %>
      <li>
        <p class="summary"><%= review.quote %></p>
        <p class='info'><%= review.critic %> | <%= review.date %></p>
      </li>
    <% }) %>
    <% } %>
    </ul>
    """

  return {
    layout          : _.template(layout)
    loader          : _.template(loader)
    simple          : _.template(simple)
    detailed        : _.template(detailed)
    similar_partial : _.template(similar_partial)
    reviews_partial : _.template(reviews_partial)
  }
