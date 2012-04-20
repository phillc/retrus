Retrospectives = new Meteor.Collection("retrospectives")

Meteor.subscribe 'retrospectives', ->
  console.log('hello, ')

Template.retrospectives_list.retrospectives = ->
  Retrospectives.find()
