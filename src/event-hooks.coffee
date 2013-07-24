  EventHooks =

    start: (router) ->

      # Handle any links to backbone navigator
      $(document).on 'click', 'a[href^="/"]', (event) ->
        href = $(event.currentTarget).attr('href')
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        router.navigate url, trigger: true
