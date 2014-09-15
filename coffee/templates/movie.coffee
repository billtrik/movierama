define ->
  """<li>
    <img src='<%= poster %>'>
    <h1><%= title %></h1>
    <p class='info'><%= release_date %>, <%= runtime %> mins, <%= rating %>/100</p>
    <p class="actors">Actors: <%= _.forEach(cast, function(name) { name }) %></p>
    <p class="summary"><%= synopsis %></p>
  </li>"""