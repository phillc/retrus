Template.group.show = ->
  !!Session.get("groupPage")

Template.group.groupId = ->
  Session.get "groupPage"
