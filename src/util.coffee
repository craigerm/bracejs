  Util =

    # Ensures that a key exists on the class. I.e is set
    ensure: (context, key, className) ->
      return if context[key]
      throw new Error("The value '#{key}' must be set on '#{className}'")

    pluralize: (word) ->
      len = word.length
      return word + 'es' if word.match /(o|s)$/i
      return word.substring(0, len - 1)  + 'ves' if word.match /f$/i
      return word + 's'

    # Example change "name" to "Name"
    capitalize: (str) ->
      str.substr(0, 1).toUpperCase() + str.substr(1)

    # Example: change "first_name" to "First Name"
    humanize: (name) ->
      words = _.map name.split('_'), (word) -> Util.capitalize(word)
      return words.join(' ')

