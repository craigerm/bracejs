Util =

  # Ensures that a key exists on the class. I.e is set
  ensure: (context, key, className) ->
    return if context[key]
    throw new Error("The value '#{key}' must be set on the sub class of 'Spine.#{className}'")

  pluralize: (str) ->
    last = str.substr(str.length - 1)
    return str + 'es' if last is 's'
    return str + 's'

  # Example change "name" to "Name"
  capitalize: (str) ->
    str.substr(0, 1).toUpperCase() + str.substr(1)

  # Example: change "first_name" to "First Name"
  humanize: (name) ->
    words = _.map name.split('_'), (word) -> Util.capitalize(word)
    return words.join(' ')
