Template.standup.show = ->
  Session.get("currentPage") == "standup"

Template.standup.events =
  "submit #new-standup-member": ->
    memberName = $("#new-standup-member-name").val()
    $("#new-standup-member-name").val("")
    StandupMembers.insert
      name: memberName
      group: Session.get "currentGroup"
      order: Math.random()
  "click .standup-shuffle": ->
    group = Session.get "currentGroup"
    standupMembers = StandupMembers.find({group: Session.get("currentGroup")})
    standupMembers.forEach (member) ->
      StandupMembers.update({_id: member.id}, {$set: {order: Math.random()}})

Template.standup.members = ->
  StandupMembers.find({group: Session.get("currentGroup")}, {sort: {order: 1}})

Template.standupMember.events =
  "click .delete-standup-member": ->
    StandupMembers.remove(@_id)
