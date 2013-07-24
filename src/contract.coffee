  Brace.Contract =
    notEmpty: (arr, msg) ->
      return if arr && arr.length > 0
      throw new Error(msg)


