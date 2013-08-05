  Handlebars.registerHelper 'json', (obj) ->
    JSON.stringify(obj)

  Handlebars.registerHelper 'ifequal', (a, b, context) ->
    context.fn() if a is b
