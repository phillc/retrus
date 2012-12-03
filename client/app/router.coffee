AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "group/new": "groupNew"
    "group/:id": "group"
    "group/:id/standup": "standup"
    ".*": "notFound"

  root: ->
    @_setPage("home")

  group: (groupId) ->
    @_setGroupPage "group", groupId

  standup: (groupId) ->
    @_setGroupPage "standup", groupId

  notFound: ->
    @_setPage("notFound")

  _setGroupPage: (page, group) ->
    Session.set "currentGroup", group
    @_setPage page

  _setPage: (page) ->
    Session.set "currentPage", page

this.Router = new AppRouter

Meteor.startup ->
  Backbone.history.start({ pushState: true })

  if Backbone.history && Backbone.history._hasPushState
    $(document).delegate "a", "click", (evt) ->
      console.log "link clicked"
      href = $(this).attr("href")
      protocol = this.protocol + "//"

      if (href.slice(protocol.length) != protocol)
        evt.preventDefault()
        console.log "navigating to #{href}"
        Backbone.history.navigate(href, true)
