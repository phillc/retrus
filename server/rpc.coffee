Meteor.methods
  createRoom: ->
    unless @userId
      throw new Meteor.Error(403, "Not allowed")
    Rooms.insert(name: "New Room", owner: @userId)

