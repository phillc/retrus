this.Sections = new Meteor.Collection("sections")
this.Items = new Meteor.Collection("items")

Meteor.autosubscribe ->
  retrospective_id = Session.get 'currentRetrospective'
  if retrospective_id
    Meteor.subscribe 'sections', retrospective_id

Meteor.autosubscribe ->
  sections = Sections.find()
  sections.forEach (section) ->
    Meteor.subscribe 'items', section._id

Template.retrospective.show = ->
  !!Session.get 'currentRetrospective'

Template.retrospectiveHeader.retrospectiveName = ->
  retrospective_id = Session.get 'currentRetrospective'
  Retrospectives.findOne(_id: retrospective_id)?.name

Template.retrospectiveFacilitatorNav.currentRetrospective = ->
  Session.get 'currentRetrospective'

Template.retrospectiveFacilitatorNav.show = ->
  !!Session.get 'currentRetrospective'

Template.retrospectiveFacilitatorNav.isFacilitator = ->
  !!Session.get 'facilitating'

Template.retrospectiveCreateSection.events =
  submit: ->
    Sections.insert
      name: $("#new-section-name").val()
      retrospective_id: Session.get 'currentRetrospective'
    $("#new-section-name").val("")

Template.retrospectiveBoard.sectionGroups = ->
  retrospective_id = Session.get 'currentRetrospective'
  sections = Sections.find(retrospective_id: retrospective_id).fetch()
  {sections: sections.splice(0,3)} while sections.length > 0

Template.retrospectiveSection.items = ->
  Items.find
    section_id: @_id

Template.retrospectiveCreateItem.focusOnShow = (anything) ->
  id = @_id
  Meteor.defer ->
    $("#new-item-modal-#{id}").on 'shown', ->
      $("#new-item-name-#{id}").focus()

Template.retrospectiveCreateItem.events =
  "submit form": ->
    Items.insert
      body: $("#new-item-name-#{@_id}").val()
      section_id: @_id
      agree: 1
      disagree: 0
    $("#new-item-modal-#{@_id}").modal('hide')
    $("#new-item-name-#{@_id}").val("")

Template.retrospectiveItem.events =
  'click .retrospective-agree': ->
    Items.update { _id: @_id }, { $inc: { agree: 1 } }
  'click .retrospective-disagree': ->
    Items.update { _id: @_id }, { $inc: { disagree: 1 } }

