Template.group.show = ->
  Session.get("currentPage") == "group"

Template.group.groupId = ->
  Session.get "currentGroup"
