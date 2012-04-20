Retrospectives = this.Retrospectives = new Meteor.Collection("retrospectives")

Meteor.publish 'retrospectives', ->
  Retrospectives.find()
