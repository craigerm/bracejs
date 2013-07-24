  Contract =
    notEmpty: (arr, msg) ->
      return if arr && arr.length > 0
      throw new Error(msg)

    present: (obj, msg) ->
      throw new Error msg unless obj



