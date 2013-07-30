  Contract =

    notEmpty: (arr, msg) ->
      @fail(msg) unless arr && arr.length > 0

    present: (obj, msg) ->
      @fail(msg) unless obj

    fail: (msg) ->
      error = new Error msg
      error.name = 'ContractError'
      throw error




