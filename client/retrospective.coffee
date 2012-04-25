Meteor.autosubscribe ->
  retrospective_id = Session.get 'currentRetrospective'
  if retrospective_id
    Meteor.subscribe 'sections', retrospective_id

Template.retrospectiveFacilitatorNav.show = ->
  Session.get 'facilitating'

Template.retrospectiveCreateSection.events =
  submit: ->
    id = Sections.insert
      name: $("#new-section-name").val()
      retrospective_id: Session.get 'currentRetrospective'

Template.retrospectiveBoard.sections = ->
  Sections.find
    retrospective_id: Session.get 'currentRetrospective'


