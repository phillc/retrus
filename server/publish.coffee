Retrospectives = this.Retrospectives = new Meteor.Collection("retrospectives")
Sections = this.Sections = new Meteor.Collection("sections")
Items = this.Items = new Meteor.Collection("items")

Meteor.publish 'retrospectives', ->
  Retrospectives.find()

Meteor.publish 'sections', (retrospective_id) ->
  Sections.find retrospective_id: retrospective_id

Meteor.publish 'items', (section_id) ->
  Items.find section_id: section_id
