AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "group/new": "groupNew"
    "group/:id": "group"
    "group/:id/edit": "groupEdit"
    "group/:id/standup": "standup"
    "group/:id/standup/light": "standupLight"
    ".*": "notFound"

  root: ->
    @_setPage
      home: true

  group: (groupId) ->
    @_setGroupPage
      group: true
      groupId: groupId

  groupEdit: (groupId) ->
    @_setGroupPage
      groupEdit: true
      groupId: groupId

  standupLight: (groupId) ->
    @_setGroupPage
      standup: true
      groupId: groupId
      light: true

  standup: (groupId) ->
    @_setGroupPage
      standup: true
      groupId: groupId

  notFound: ->
    @_setPage notFound: true

  _setGroupPage: (options) ->
    group = Groups.findOne
      $or: [
        {_id: options.groupId},
        {code: options.groupId}
      ]
    if group
      options.groupId = group._id
      @_setPage options
    else
      @_setPage notFound: true

  _setPage: (options) ->
    console.log options
    Session.set "homePage", !!options.home
    Session.set "groupPage", !!options.group
    Session.set "groupEditPage", !!options.groupEdit
    Session.set "standupPage", !!options.standup
    Session.set "currentGroupId", options.groupId
    Session.set "notFoundPage", !!options.notFound
    Session.set "lightMode", !!options.light

this.Router = new AppRouter

Meteor.startup ->
  Meteor.subscribe "groups", ->
    Backbone.history.start({ pushState: true })

    $(document).delegate "a:not([data-bypass])", "click", (event) ->
      href = $(event.currentTarget).attr('href')

      if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
        event.preventDefault()

        Backbone.history.navigate(href, true)
        return false
