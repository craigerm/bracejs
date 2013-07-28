  EventHooks =

    start: (router) ->

      # Handle any links to backbone navigator
      $(document).on 'click', 'a[href^="/"]', (event) ->
        return if event.ctrlKey
        return if event.shiftKey
        href = $(event.currentTarget).attr('href')
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        router.navigate url, trigger: true
