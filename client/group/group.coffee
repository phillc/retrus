Template.group.show = ->
  Session.equals("groupPage", true)

Template.group.groupId = ->
  Session.get "currentGroupId"
