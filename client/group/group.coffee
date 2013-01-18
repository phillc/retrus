Template.group.show = ->
  Session.equals("groupPage", true)

Template.group.groupId = ->
  Session.get "currentGroupId"

Template.group.groupName = ->
  Groups.findOne(Session.get("currentGroupId"))?.name

Template.group.groupCode = ->
  Groups.findOne(Session.get "currentGroupId")?.code

Template.groupEdit.show = ->
  Session.equals("groupEditPage", true)

Template.groupEdit.groupId = ->
  Session.get "currentGroupId"

Template.groupEdit.groupName = ->
  Groups.findOne(Session.get("currentGroupId"))?.name

Template.groupEdit.groupCode = ->
  Groups.findOne(Session.get "currentGroupId")?.code

Template.groupEdit.events =
  "submit #group-edit": ->
    Groups.update Session.get("currentGroupId"),
      $set:
        name: $("#group-name").val()
        code: $("#group-code").val()
