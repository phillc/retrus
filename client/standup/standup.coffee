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
      standupMembers = StandupMembers.find({group: Session.get("currentGroupId")})
      standupMembers.forEach (member) ->
        randomNumber = Math.floor(Math.random() * 1000000)
        StandupMembers.update({_id: member._id}, {$set: {position: randomNumber, selected: false}})
      Groups.update({_id: Session.get("currentGroupId")}, {$set: {standupLastShuffled: Standup.currentTime()}})

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
  currentTime: ->
    now = new Date()
    utc = now.getTime() + now.getTimezoneOffset() * 60000


Template.standup.show = ->
  Session.equals("standupPage", true)

Template.standup.lightMode = ->
  Session.equals "lightMode", true

Template.standup.events =
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

Template.standupShuffle.events =
  "click .standup-shuffle": ->
    Standup.Members.shuffle()

Template.standupShuffle.lastShuffled = ->
  shuffled = Groups.findOne(Session.get("currentGroupId"))?.standupLastShuffled
  if !shuffled
    return ""

  minutes = (Standup.currentTime() - shuffled) / 60000
  if minutes <= 2
    "(few minutes ago)"
  else if minutes <= 5
    "(< 5 minutes ago)"
  else if minutes <= 60
    "(< an hour ago)"
  else if minutes < 300
    "(few hours ago)"
  else
    ""



Template.standupMember.events =
  "click .delete-standup-member": ->
    StandupMembers.remove(@_id)
  "click .standup-member-name": ->
    StandupMembers.update({group: Session.get("currentGroupId")}, {$set: {selected: false}}, {multi: true})
    StandupMembers.update(@_id, {$set: {selected: true}})

Template.standupMemberActions.show = ->
  Session.equals("standupEditing", true)

Template.standupLight.show = ->
  Session.equals "lightMode", true

Template.standupLight.groupId = ->
  Session.get "currentGroupId"

