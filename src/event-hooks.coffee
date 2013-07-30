  EventHooks =

    start: (router) ->

      # Handle any links to backbone navigator
      $(document).on 'click', 'a[href^="/"]', (event) ->
        return if event.ctrlKey || event.shiftKey || event.metaKey
        href = $(event.currentTarget).attr('href')
        event.preventDefault()
        url = href.replace(/^\//,'').replace('\#\!\/','')
        router.navigate url, trigger: true
