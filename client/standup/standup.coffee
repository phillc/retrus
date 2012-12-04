Template.standup.show = ->
  !!Session.get("standupPage")

Template.standup.events =
  "submit #new-standup-member": ->
    memberName = $("#new-standup-member-name").val()
    $("#new-standup-member-name").val("")
    StandupMembers.insert
      name: memberName
      group: Session.get "standupPage"
      order: Math.random()
  "click .standup-shuffle": ->
    group = Session.get "standupPage"
    standupMembers = StandupMembers.find({group: Session.get("standupPage")})
    standupMembers.forEach (member) ->
      StandupMembers.update({_id: member.id}, {$set: {order: Math.random()}})

Template.standup.members = ->
  StandupMembers.find({group: Session.get("standupPage")}, {sort: {order: 1}})

Template.standupMember.events =
  "click .delete-standup-member": ->
    StandupMembers.remove(@_id)

Template.standupActionsHeader.show = ->
  !Session.get("lightMode")

Template.standupActions.show = ->
  !Session.get("lightMode")
