Meteor.subscribe "groups"
# Meteor.autosubscribe ->
  # Meteor.subscribe "standup_members", group: 
Meteor.subscribe "standup_members"

Template.home.show = ->
  Session.get("currentPage") == "home"
Template.home.canCreateGroup = ->
  !!Meteor.userId()
Template.home.groups = ->
  Groups.find()

Template.group.show = ->
  Session.get("currentPage") == "group"
Template.group.groupId = ->
  Session.get "currentPageParam"

Template.standup.show = ->
  Session.get("currentPage") == "standup"
Template.standup.events =
  "submit #new-standup-member": (huh) ->
    memberName = $("#new-standup-member-name").val()
    $("#new-standup-member-name").val("")
    StandupMembers.insert
      name: memberName
      group: Session.get "currentPageParam"
Template.standup.members = ->
  StandupMembers.find()

AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "group/new": "groupNew"
    "group/:id": "group"
    "group/:id/standup": "standup"
    ".*": "notFound"

  root: ->
    @setPage("home")

  groupNew: ->
    Meteor.call "createGroup", (err, groupId) =>
      @navigate "group/#{groupId}"

  group: (groupId) ->
    @setPage "group", groupId

  standup: (groupId) ->
    console.log "Setting page as standup"
    @setPage "standup", groupId

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
      console.log "link clicked"
      href = $(this).attr("href")
      protocol = this.protocol + "//"

      if (href.slice(protocol.length) != protocol)
        evt.preventDefault()
        Backbone.history.navigate(href, true)
