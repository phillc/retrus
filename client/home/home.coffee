Template.home.events =
  "click #new-group": ->
    Meteor.call "createGroup", (err, groupId) ->
      Backbone.history.navigate("group/#{groupId}", true)

Template.home.show = ->
  !!Session.get("homePage")

Template.home.canCreateGroup = ->
  !!Meteor.userId()

Template.home.groups = ->
  Groups.find({owner: Meteor.userId()})
