EventHooks =
  start: (router) ->

    # Handle any links to backbone navigator
    $(document).on 'click', 'a[href^="/"]', (event) ->
      href = $(event.currentTarget).attr('href')
      event.preventDefault()

      # Handle any allowed links. Logout etc.
      # Handle alt key, ctrl, etc..   
      url = href.replace(/^\//,'').replace('\#\!\/','')

      router.customRouter.navigate url, trigger: true
