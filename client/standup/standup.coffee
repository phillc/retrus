Template.standup.show = ->
  Session.equals("standupPage", true)

Template.standup.events =
  "submit #new-standup-member": ->
    memberName = $("#new-standup-member-name").val()
    $("#new-standup-member-name").val("")
    StandupMembers.insert
      name: memberName
      group: Session.get "currentGroupId"
      order: 2
  "click .standup-shuffle": ->
    group = Session.get "currentGroupId"
    standupMembers = StandupMembers.find({group: Session.get("currentGroupId")})
    standupMembers.forEach (member) ->
      StandupMembers.update({_id: member._id}, {$set: {order: Math.random()}})

Template.standup.members = ->
  StandupMembers.find({group: Session.get("currentGroupId")}, {sort: {order: 1}})

Template.standupMember.events =
  "click .delete-standup-member": ->
    StandupMembers.remove(@_id)

Template.standupActionsHeader.show = ->
  !Session.get("lightMode")

Template.standupActions.show = ->
  !Session.get("lightMode")
