AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "group/new": "groupNew"
    "group/:id": "group"
    "group/:id/standup": "standup"
    "group/:id/standup/light": "standupLight"
    ".*": "notFound"

  root: ->
    @_setPage("home")

  group: (groupId) ->
    @_setPage group: groupId

  standupLight: (groupId) ->
    @_setPage
      standup: groupId
      light: true
  standup: (groupId) ->
    @_setPage standup: groupId

  notFound: ->
    @_setPage("notFound")

  _setPage: (options) ->
    console.log options
    Session.set "homePage", (options == "home")
    Session.set "groupPage", options.group
    Session.set "standupPage", options.standup
    Session.set "lightMode", !!options.light

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
