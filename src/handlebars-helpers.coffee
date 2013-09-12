  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  Handlebars.registerHelper 'default', (value, defaultValue) ->
    return value if value
    return defaultValue

  Handlebars.registerHelper 'ifempty', (arr, context) ->
    context.fn(@) if arr.length == 0
    context.inverse(@) if arr.length > 0

  Handlebars.registerHelper 'ifequal', (a, b, context) ->
    if a is b
      context.fn(@)
    else
      context.inverse(@)

  Handlebars.registerHelper 'capitalize', (str) ->
    Util.capitalize(str)

