class App.RetrospectivesController extends App.ApplicationController
  @param "name"
###
  index: ->
    App.Retrospective.where(@criteria()).all (error, collection) =>
      @render "index"
    
  new: ->
    resource = new App.Retrospective
    @render "new"
    
  create: ->
    App.Retrospective.create @params.retrospective, (error, resource) =>
      if error
        @redirectTo "new"
      else
        @redirectTo @urlFor(resource)
    
  show:  ->
    App.Retrospective.find @params.id, (error, resource) =>
      if resource
        @render "show"
      else
        @redirectTo "index"
    
  edit: ->
    App.Retrospective.find @params.id, (error, resource) =>
      if resource
        @render "edit"
      else
        @redirectTo "index"
      
  update: ->
    App.Retrospective.find @params.id (error, resource) =>
      if error
        @redirectTo "edit"
      else
        resource.updateAttributes @params.retrospective, (error) =>
          @redirectTo @urlFor(resource)
    
  destroy: ->
    App.Retrospective.find @params.id, (error, resource) =>
      if error
        @redirectTo "index"
      else
        resource.destroy (error) =>
          @redirectTo "index"
    
###
