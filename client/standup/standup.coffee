do ->
  $(document).keydown (e) ->
    up = [38, 75]
    down = [40, 74]
    if up.indexOf(e.keyCode) >= 0
      Standup.Members.previous()
    else if down.indexOf(e.keyCode) >= 0
      Standup.Members.next()
Standup = do ->
  class Members
    findSelected: ->
      StandupMembers.findOne({group: Session.get("currentGroupId"), selected: true})

    findAll: ->
      StandupMembers.find({group: Session.get("currentGroupId")}, {sort: {position: 1}})

    findUnselected: (options) ->
      selector =
        group: Session.get("currentGroupId"),
        selected: false,
      selector.position = {}
      selector.position["$#{options.direction}"] = @findSelected()?.position || 0

      StandupMembers.findOne(selector, {sort: {position: (options.sort || 1)}})

    shuffle: ->
      group = Session.get "currentGroupId"
      standupMembers = StandupMembers.find({group: Session.get("currentGroupId")})
      standupMembers.forEach (member) ->
        StandupMembers.update({_id: member._id}, {$set: {position: Math.random(), selected: false}})

    selectUnselected: (direction, sort) ->
      toBeSelected = @findUnselected direction: direction, sort: sort
      StandupMembers.update({group: Session.get("currentGroupId")}, {$set: {selected: false}}, {multi: true})
      if toBeSelected
        StandupMembers.update(toBeSelected._id, {$set: {selected: true}}, {multi: false})

    next: ->
      @selectUnselected "gt", 1

    previous: ->
      @selectUnselected "lt", -1

  Members: new Members

Template.standup.show = ->
  Session.equals("standupPage", true)

Template.standup.events =
  "click .standup-shuffle": ->
    Standup.Members.shuffle()
  "click .standup-edit": ->
    Session.set "standupEditing", !Session.get("standupEditing")
  "click .standup-next": ->
    Standup.Members.next()
  "click .standup-previous": ->
    Standup.Members.previous()

Template.standup.members = ->
  Standup.Members.findAll()

Template.standupMemberNew.events =
  "submit #new-standup-member": ->
    memberName = $("#new-standup-member-name").val()
    $("#new-standup-member-name").val("")
    StandupMembers.insert
      name: memberName
      group: Session.get "currentGroupId"
      position: new Date().valueOf()

Template.standupMemberNew.show = ->
  Session.equals "lightMode", false

Template.standupActions.show = ->
  Session.equals "lightMode", false

Template.standupActions.googleData = ->
  Session.get "currentGroupId"

Template.standupMember.events =
  "click .delete-standup-member": ->
    StandupMembers.remove(@_id)
  "click": ->
    StandupMembers.update({group: Session.get("currentGroupId")}, {$set: {selected: false}}, {multi: true})
    StandupMembers.update(@_id, {$set: {selected: true}})

Template.standupMemberActionsHeader.show = ->
  Session.equals("standupEditing", true)

Template.standupMemberActions.show = ->
  Session.equals("standupEditing", true)
