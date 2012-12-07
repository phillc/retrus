# Meteor.autosubscribe ->
  # Meteor.subscribe "standup_members", group: 
Meteor.subscribe "standup_members"

Template.notFound.show = ->
  Session.equals "notFoundPage", true

Template.footer.show = ->
  Session.equals "lightMode", false

Template.navigation.show = ->
  Session.equals "lightMode", false
