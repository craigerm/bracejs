  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  Handlebars.registerHelper 'default', (value, defaultValue) ->
    return value if value
    return defaultValue

  Handlebars.registerHelper 'ifequal', (a, b, context) ->
    if a is b
      context.fn(@)
    else
      context.inverse(@)
