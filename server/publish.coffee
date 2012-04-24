Retrospectives = this.Retrospectives = new Meteor.Collection("retrospectives")
Sections = this.Sections = new Meteor.Collection("sections")

Meteor.publish 'retrospectives', ->
  Retrospectives.find()

Meteor.publish 'sections', (retrospective_id) ->
  Sections.find retrospective_id: retrospective_id
