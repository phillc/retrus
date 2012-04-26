Sections = new Meteor.Collection("sections")
Items = new Meteor.Collection("items")

Meteor.autosubscribe ->
  retrospective_id = Session.get 'currentRetrospective'
  if retrospective_id
    Meteor.subscribe 'sections', retrospective_id

Meteor.autosubscribe ->
  sections = Sections.find()
  sections.forEach (section) ->
    Meteor.subscribe 'items', section._id

Template.retrospectiveFacilitatorNav.show = ->
  Session.get 'facilitating'

Template.retrospectiveCreateSection.events =
  submit: ->
    Sections.insert
      name: $("#new-section-name").val()
      retrospective_id: Session.get 'currentRetrospective'
    $("#new-section-name").val("")

Template.retrospectiveBoard.sections = ->
  Sections.find
    retrospective_id: Session.get 'currentRetrospective'

Template.retrospectiveSection.items = ->
  Items.find
    section_id: @_id

Template.retrospectiveCreateItem.events =
  "submit form": ->
    Items.insert
      body: $("#new-item-name-#{@_id}").val()
      section_id: @_id
    $("#new-item-modal-#{@_id}").modal('hide')
    $("#new-item-name-#{@_id}").val("")


