  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  Handlebars.registerHelper 'list', (arr) ->
    if arr then arr.join(', ') else ''

  Handlebars.registerHelper 'default', (value, defaultValue) ->
    value or defaultValue

  Handlebars.registerHelper 'ifempty', (arr, context) ->
    if arr.length is 0 then context.fn(@) else context.inverse(@)

  Handlebars.registerHelper 'ifequal', (a, b, context) ->
    if a is b
      context.fn(@)
    else
      context.inverse(@)

  Handlebars.registerHelper 'capitalize', (str) ->
    Util.capitalize(str)

