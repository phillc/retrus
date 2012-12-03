Template.home.events =
  "click #new-group": ->
    Meteor.call "createGroup", (err, groupId) ->
      Backbone.history.navigate("group/#{groupId}", true)

Template.home.show = ->
  Session.get("currentPage") == "home"

Template.home.canCreateGroup = ->
  !!Meteor.userId()

Template.home.groups = ->
  Groups.find()
