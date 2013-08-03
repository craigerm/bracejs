  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  Handlebars.registerHelper 'ifequal', (a, b) ->
    return a == b
