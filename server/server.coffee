Meteor.methods
  createGroup: ->
    unless @userId
      throw new Meteor.Error(403, "Not allowed")
    Groups.insert(name: "New Group", owner: @userId)

Meteor.publish "groups", ->
  Groups.find()

Meteor.publish "standup_members", ->
  StandupMembers.find()

StandupMembers.allow
  insert: (userId, standupMember) ->
    !!standupMember?.name && !!standupMember?.group
  update: (userId, docs, fields, modifier) ->
    true
  remove: (userId, docs) ->
    true

