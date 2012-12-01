Template.home.show = ->
  Session.get("currentPage") == "home"

Template.room.show = ->
  Session.get("currentPage") == "room"

Template.room.roomId = ->
  Session.get "currentPageParam"

Template.home.canCreateRoom = ->
  !!@userId

AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "room/new": "roomNew"
    "room/:id": "room"
    "room/:id/standup": "standup"
    ".*": "notFound"

  root: ->
    @setPage("home")

  roomNew: ->
    Meteor.call "createRoom", (err, roomId) =>
      @navigate "room/#{roomId}"

  room: (roomId) ->
    @setPage "room", roomId

  standup: (roomId) ->
    @setPage "standup", roomId

  notFound: ->
    @setPage("notFound")

  setPage: (page, pageParam) ->
    console.log "Navigating to #{page}, #{pageParam}"
    Session.set "currentPage", page
    Session.set "currentPageParam", pageParam

this.Router = new AppRouter

Meteor.startup ->
  Backbone.history.start({ pushState: true })

  if Backbone.history && Backbone.history._hasPushState
    $(document).delegate "a", "click", (evt) ->
      href = $(this).attr("href")
      protocol = this.protocol + "//"

      if (href.slice(protocol.length) != protocol)
        evt.preventDefault()
        Backbone.history.navigate(href, true)
