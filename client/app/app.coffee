Meteor.subscribe "groups"
# Meteor.autosubscribe ->
  # Meteor.subscribe "standup_members", group: 
Meteor.subscribe "standup_members"

Template.notFound.show = ->
  !!Session.get "notFoundPage"
