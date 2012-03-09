class App.ApplicationController extends Tower.Controller
  @layout "application"
  
  welcome: ->
    @render "welcome"
